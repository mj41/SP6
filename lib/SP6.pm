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

method get_eval_str(Str $tfpath) {
	my $fpath = self.templ_fpath($tfpath);

	die X::SP6::Error.new(
		reason => "Template file $tfpath (path '$fpath') not found."
	) unless $fpath.IO ~~ :e;
	say "Template fpath: '$fpath'" if $.debug;

	return 'Qc ｢' ~ slurp($fpath) ~ '｣;';
}

method get_sp6_file_code(Str $tfpath) {
	my $code = self.get_eval_str($tfpath);
	say "code: {$code.perl}" if $.debug;
	return $code;
}

multi method process_file(Str $tfpath) {
	my %v;
	use SP6::ProcessMethods;

	sub include($inc_tfpath) {
		return self.process_file($inc_tfpath);
	}

	my $code = self.get_sp6_file_code($tfpath);
	my $out = EVAL $code;
	return $out;

	CATCH {
		when X::SP6::Error { die $_ }
		when X::Comp { die "Error while compiling template '$tfpath':\n$_" }
		default { die "Error running template '$tfpath':\n$_" }
	}
}

multi method process_file_inside(Str $tfpath, Str :$inside_tfpath!) {
	my %v;
	use SP6::ProcessMethods;

	sub main_part {
		return self.process_file($tfpath);
	}

	sub include($inc_tfpath) {
		return self.process_file($inc_tfpath);
	}

	my $code = self.get_sp6_file_code($inside_tfpath);
	my $out = EVAL $code;
	return $out;

	CATCH {
		when X::SP6::Error { die $_ }
		when X::Comp { die "Error while compiling template '$tfpath' inside '$inside_tfpath':\n$_" }
		default { die "Error while running template '$tfpath' inside '$inside_tfpath':\n$_" }
	}
}

method process(Str :$tfpath!, Str :$inside_tfpath, Bool :$debug) {
	return self.process_file($tfpath) unless defined $inside_tfpath;
	return self.process_file_inside($tfpath, :$inside_tfpath);
}
