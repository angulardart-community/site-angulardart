import os
import net.http

fn main() {
	url_base := 'https://raw.githubusercontent.com/angulardart-community/site-angulardart/master/examples/ng/doc/'

	target_example := os.getwd().split('/').last()
	println('Target example: $target_example')

	if os.args.len < 2 {
		println('Usage: <file-to-merge>')
		exit(0)
	}

	for file in os.args[1..] {
		if os.exists(file) {
			eprintln('Warning: $file already exists. This will overwrite it.')
			exit(1)
		}

		http.download_file(os.join_path(url_base, target_example, file), file) ?

		println('Downloaded $file')
	}

	// file := os.join_path(os.args[1])
}
