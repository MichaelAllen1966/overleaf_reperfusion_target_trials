# Builds the external documents used by the xr package (see main.tex), so that the
# main paper and the supplement can cite each other's table, figure and section
# numbers when they are compiled as separate PDFs.
# Adapted from John Collins' xr_latexmkrc example (CTAN, support/latexmk/example_rcfiles).

@sub_doc_options = ('-pdf');   # compile external documents with pdflatex

# Pattern for xr's message about a missing .aux file (needed for older latexmk)
push @file_not_found, '^No file\\s*(.+)\s*$';

add_cus_dep( 'tex', 'aux', 0, 'makeexternaldocument' );
sub makeexternaldocument {
    # Only build the two wrapper documents; other .aux files are made by pdflatex itself
    return 0 unless $_[0] =~ /(^|\/)(supplement|mainpaper)$/;
    if ( $root_filename ne $_[0] ) {
        my ($base_name, $path) = fileparse( $_[0] );
        pushd $path;
        my $return = system "latexmk", @sub_doc_options, $base_name;
        popd();
        return $return;
    }
    return 0;
}
