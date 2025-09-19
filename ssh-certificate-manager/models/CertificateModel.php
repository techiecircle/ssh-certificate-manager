<?php
class CertificateModel {
    private $table;
    public function __construct() {
        global $wpdb;
        $this->table = $wpdb->prefix . 'ssh_cert_requests';
    }
    public function create_table() {
        global $wpdb;
        $charset = $wpdb->get_charset_collate();
        $sql = "CREATE TABLE {$this->table} (
            id BIGINT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(100) NOT NULL,
            public_key TEXT NOT NULL,
            status VARCHAR(20) DEFAULT 'pending',
            cert_content TEXT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            email_sent TINYINT DEFAULT 0
        ) $charset;";
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        dbDelta($sql);
    }
    public function insert_request($username, $public_key) {
        global $wpdb;
        $wpdb->insert($this->table,[
            'username' => sanitize_text_field($username),
            'public_key' => sanitize_textarea_field($public_key),
            'status' => 'pending'
        ]);
    }
    public function get_requests($status=null) {
        global $wpdb;
        if($status){
            return $wpdb->get_results($wpdb->prepare("SELECT * FROM {$this->table} WHERE status=%s",$status));
        }
        return $wpdb->get_results("SELECT * FROM {$this->table} ORDER BY created_at DESC");
    }
    public function update_status($id,$status,$cert_content=null) {
        global $wpdb;
        $wpdb->update($this->table,[
            'status'=>$status,
            'cert_content'=>$cert_content
        ],['id'=>$id]);
    }
	public function get_request_by_id($id) {
    	global $wpdb;
    	$table = $wpdb->prefix . "ssh_cert_requests";
    	return $wpdb->get_row(
        $wpdb->prepare("SELECT * FROM $table WHERE id = %d", $id)
    );
	}
}
