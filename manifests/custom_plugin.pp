# Define: nagios::custom_plugin
define nagios::custom_plugin (
    $gitrepo = "false",
    $plugin_url = "false",
    $local_path,
    $file_name,
    ) {
    if ($gitrepo != "false"){
        exec {
            "clone custom nagios plugin ${name} from gitrepo":
                command    => "git archive --format=tar --remote=${gitrepo} HEAD ${file_name} | tar xf -",
                cwd        => "${local_path}",
                logoutput  => on_failure,
                onlyif     => ["test -d ${local_path}"],
                unless     => ["test -f ${local_path}/${file_name}"],
        }
    } elsif ($plugin_url != "false") {
        exec {
            "wget nagios plugin ${name}":
            command => "/usr/bin/wget $plugin_url",
            cwd     => "${local_path}",
            onlyif  => ["test -d ${local_path}"],
            unless  => ["test -f ${local_path}/${file_name}"],
        }
    } else {
        fail("You have to provide gitrepo or plugin_url")
    }
}
