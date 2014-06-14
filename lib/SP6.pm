class SP6;

has $.templ_dir;
has $.debug;

class X::SP6::Error is Exception {
     has $.reason;
     method message() { return $.reason };
}

method templ_fpath(Str $fname) {
	return $.templ_dir ~ '/' ~ $fname;
}

method get_eval_str(Str $base_name) {
	my $fpath = self.templ_fpath($base_name);

	die X::SP6::Error.new(
		reason => "Template file $base_name (path '$fpath') not found."
	) unless $fpath.IO ~~ :e;
	say "Template fpath: '$fpath'" if $.debug;

	return 'Qc ｢' ~ slurp($fpath) ~ '｣;';
}

method get_sp6_file_code(Str $base_name) {
	my $code = self.get_eval_str($base_name);
	say "code: {$code.perl}" if $.debug;
	return $code;
}

multi method process(Str $base_name) {
	my %v;
	use SP6::ProcessMethods;

	sub include($inc_base_name) {
		return self.process($inc_base_name);
	}

	my $code = self.get_sp6_file_code($base_name);
	my $out = EVAL $code;
	return $out;

	CATCH {
		when X::SP6::Error { die $_ }
		when X::Comp { die "Error compiling template '$base_name':\n$_" }
		default { die "Error compiling template '$base_name':\n$_" }
	}
}

multi method process(Str $base_name, Str :$inside!) {
	my %v;
	use SP6::ProcessMethods;

	sub main_part {
		return self.process($base_name);
	}

	sub include($inc_base_name) {
		return self.process($inc_base_name);
	}

	my $code = self.get_sp6_file_code($inside);
	my $out = EVAL $code;
	return $out;

	CATCH {
		when X::SP6::Error { die $_ }
		when X::Comp { die "Error compiling template '$base_name':\n$_" }
		default { die "Error compiling template '$base_name':\n$_" }
	}
}

multi method process_args(Str $base_name, Str :$inside, Bool :$debug) {
	return self.process($base_name) unless defined $inside;
	return self.process($base_name, :$inside);
}
