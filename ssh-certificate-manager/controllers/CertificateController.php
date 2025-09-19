<?php
class CertificateController {
    private $model;
    public function __construct() {
        $this->model = new CertificateModel();
    }
    public function register() {
        register_activation_hook(__FILE__, [$this->model,'create_table']);
        add_shortcode('ssh_cert_request',[$this,'render_request_form']);
        add_action('admin_menu',[$this,'admin_menu']);
        add_action('admin_post_ssh_cert_approve',[$this,'approve_request']);
        add_action('admin_post_ssh_cert_deny',[$this,'deny_request']);
    }
    public function render_request_form(){
        ob_start();
        if($_SERVER['REQUEST_METHOD']==='POST' && isset($_POST['ssh_cert_request'])){
            $this->model->insert_request($_POST['username'],$_POST['public_key']);
            echo "<p>Your request has been submitted. You will be notified once approved.</p>";
        }
        include SSH_CERT_MANAGER_PATH.'views/request-form.php';
        return ob_get_clean();
    }
	
	/*
    public function admin_menu(){
        add_menu_page('SSH Certificates','SSH Certificates','manage_options','ssh-certificates',[$this,'admin_page'],'dashicons-lock',6);
        add_submenu_page('ssh-certificates','Settings','Settings','manage_options','ssh-certificates-settings',[$this,'settings_page']);
    }
	*/
	
	public function admin_menu() {
    // Main menu: SSH Certificates (dummy callback just to show menu)
    add_menu_page(
        'SSH Certificates',
        'SSH Certificates',
        'manage_options',
        'ssh-certificates',
        '', // leave empty; we will use the submenu for actual pages
        'dashicons-lock',
        6
    );

    // Submenu 1: Requests (actual requests table)
    add_submenu_page(
        'ssh-certificates',
        'Requests',
        'Requests',
        'manage_options',
        'ssh-certificates-requests',
        [$this, 'admin_requests_page']
    );

    // Submenu 2: Settings
    add_submenu_page(
        'ssh-certificates',
        'Settings',
        'Settings',
        'manage_options',
        'ssh-certificates-settings',
        [$this, 'settings_page']
    );
   }


	
	public function admin_requests_page(){
   	 	$requests = $this->model->get_requests();
    	include SSH_CERT_MANAGER_PATH.'views/admin-list.php';
	}

	
    public function admin_page(){
        $requests=$this->model->get_requests();
        include SSH_CERT_MANAGER_PATH.'views/admin-list.php';
    }
	
	
    public function settings_page(){
        if($_SERVER['REQUEST_METHOD']==='POST' && isset($_POST['ca_key_path'])){
            update_option('ssh_cert_ca_key_path',sanitize_text_field($_POST['ca_key_path']));
            echo "<div class='updated'><p>Settings saved.</p></div>";
        }
        include SSH_CERT_MANAGER_PATH.'views/settings.php';
    }
    public function approve_request(){
    if(!current_user_can('manage_options')) wp_die('Unauthorized');

    $id = intval($_GET['id']);
    $req = $this->model->get_request_by_id($id); // ✅ fetch specific request

    if(!$req) {
        wp_die('Request not found');
    }

    $ca_key = get_option('ssh_cert_ca_key_path', SSH_CERT_MANAGER_PATH.'ssh_ca');
    $tmp_pub = tempnam(sys_get_temp_dir(), "ssh_pub_");
    $tmp_cert = tempnam(sys_get_temp_dir(), "ssh_cert_");

    file_put_contents($tmp_pub, $req->public_key);

    $cmd = sprintf(
        'ssh-keygen -s %s -I %s -n %s -V +52w %s -z %d -f %s',
        escapeshellarg($ca_key),
        escapeshellarg($req->username),
        escapeshellarg($req->username),
        escapeshellarg($tmp_pub),
        time(),
        escapeshellarg($tmp_cert)
    );

    shell_exec($cmd);

    $cert_content = @file_get_contents($tmp_cert.'-cert.pub');
    $this->model->update_status($id, 'approved', $cert_content);

    @unlink($tmp_pub);
    if(file_exists($tmp_cert.'-cert.pub')) unlink($tmp_cert.'-cert.pub');

    wp_mail($req->username.'@example.com','Certificate Approved','Your certificate has been approved: '.$cert_content);

    wp_redirect(admin_url('admin.php?page=ssh-certificates-requests')); 
    exit;
	}

	public function deny_request(){
    if(!current_user_can('manage_options')) wp_die('Unauthorized');

    $id = intval($_GET['id']);
    $req = $this->model->get_request_by_id($id); // ✅ fetch specific request

    if(!$req) {
        wp_die('Request not found');
    }

    $this->model->update_status($id, 'denied');

    wp_mail($req->username.'@example.com','Certificate Denied','Your certificate request has been denied.');

    wp_redirect(admin_url('admin.php?page=ssh-certificates-requests'));
    exit;
	}
	
	public function download_certificate() {
    if(!is_user_logged_in() && !current_user_can('manage_options')) {
        wp_die('Unauthorized');
    }

    $id = intval($_GET['id']);
    $req = $this->model->get_request_by_id($id);

    if(!$req || $req->status !== 'approved' || empty($req->certificate)) {
        wp_die('Certificate not available');
    }

    // Send as file download
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="ssh_cert_'.$id.'.pub"');
    header('Content-Length: ' . strlen($req->certificate));
    echo $req->certificate;
    exit;
	}
}
