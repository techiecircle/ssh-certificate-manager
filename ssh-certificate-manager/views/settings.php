<div class="wrap"><h2>SSH Certificate Manager Settings</h2>
<form method="post">
<label>CA Private Key Path:</label><br>
<input type="text" name="ca_key_path" value="<?php echo esc_attr(get_option('ssh_cert_ca_key_path',SSH_CERT_MANAGER_PATH.'ssh_ca')); ?>" size="50"><br><br>
<button type="submit">Save Settings</button>
</form></div>
