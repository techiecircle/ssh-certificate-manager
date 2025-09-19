<?php
/*
Plugin Name: SSH Certificate Manager
Description: Manage SSH certificate requests and issuance inside WordPress with approve/deny workflow.
Version: 2.0
Author: Kryptosol LLC
*/

if (!defined('ABSPATH')) exit;

define('SSH_CERT_MANAGER_PATH', plugin_dir_path(__FILE__));
define('SSH_CERT_MANAGER_URL', plugin_dir_url(__FILE__));

require_once SSH_CERT_MANAGER_PATH . 'models/CertificateModel.php';
require_once SSH_CERT_MANAGER_PATH . 'controllers/CertificateController.php';

function ssh_cert_manager_init() {
    $controller = new CertificateController();
    $controller->register();
}

add_action('plugins_loaded', 'ssh_cert_manager_init');
add_action('admin_post_ssh_cert_download', [$controller, 'download_certificate']);
add_action('admin_post_nopriv_ssh_cert_download', [$controller, 'download_certificate']);
