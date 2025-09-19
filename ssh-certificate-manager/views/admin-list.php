<div class="wrap">
    <h1>SSH Certificate Requests</h1>

    <table class="widefat fixed striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Public Key</th>
                <th>Status</th>
                <th>Certificate</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <?php if (!empty($requests)) : ?>
            <?php foreach ($requests as $r) : ?>
                <tr>
                    <td><?php echo esc_html($r->id); ?></td>
                    <td><?php echo esc_html($r->username); ?></td>
                    <td><textarea readonly rows="4" cols="40"><?php echo esc_html($r->public_key); ?></textarea></td>
                    <td><?php echo esc_html($r->status); ?></td>
                    <td>
                        <?php if (!empty($r->certificate)) : ?>
                            <textarea readonly rows="4" cols="40"><?php echo esc_html($r->certificate); ?></textarea>
                        <?php else: ?>
                            —
                        <?php endif; ?>
                    </td>
                    <td>
                        <?php if ($r->status === 'pending') : ?>
                            <a href="<?php echo admin_url('admin-post.php?action=ssh_cert_approve&id='.$r->id); ?>" class="button button-primary">Approve</a>
                            <a href="<?php echo admin_url('admin-post.php?action=ssh_cert_deny&id='.$r->id); ?>" class="button">Deny</a>
                        <?php elseif ($r->status === 'approved' && !empty($r->certificate)) : ?>
                            <a href="<?php echo admin_url('admin-post.php?action=ssh_cert_download&id='.$r->id); ?>" class="button">Download Certificate</a>
                        <?php else: ?>
                            <em>No actions</em>
                        <?php endif; ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else : ?>
            <tr><td colspan="6">No requests found.</td></tr>
        <?php endif; ?>
        </tbody>
    </table>
</div>
