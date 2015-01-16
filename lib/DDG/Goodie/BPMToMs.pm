package DDG::Goodie::BPMToMs;
# ABSTRACT: Displays common note values in milliseconds for a given tempo measured in quarter notes per minute.

use DDG::Goodie;

zci answer_type => "bpmto_ms";
zci is_cached   => 1;

name "BPM (beats per minute) to ms (milliseconds) converter";
description "Takes a tempo as BPM (beats per minute), eg. 120, and returns the corresponding note values as milliseconds.";
primary_example_queries "120 bpm to ms";
category "conversions";
topics "music";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BPMToMs.pm";
attribution github => ["https://github.com/stefolof", "stefolof"],
            twitter => "stefolof";

triggers end => "bpm to ms", "bpm to milliseconds", "bpm to note values", "bpm to note lengths", "bpm", "bpm timings", "beats per minute to milliseconds", 
                "beats per minute to ms", "beats per minute to note values", "beats per minute to note lengths", "beats per minute", "beats per minute timings";

handle remainder => sub {
    return unless $_ =~ /^\d+$/i; # Only integer values accepted
    
    my $bpm = $_;
    
    my @note_names = ( "Whole Note", "Half Note", "Quarter Note", "1/8 Note", "1/16 Note", "1/32 Note" );
    
    # The basic note lengths for each category
    my $straight_whole_note = 240000;
    my $triplet_whole_note = 160000;
    my $dotted_whole_note = 360000;
    
    my @divisors = map { 2 ** $_ } 0 .. 5; # Create a list of divisors to calculate the values of half notes, quarter notes etc.
    
    my @straight_values = map { int( $straight_whole_note / ($bpm * $_) + 0.5) } @divisors;
    my @triplet_values = map { int( $triplet_whole_note / ($bpm * $_) + 0.5) } @divisors;
    my @dotted_values = map { int( $dotted_whole_note / ($bpm * $_) + 0.5) } @divisors;
    
    my $html_content = "<div class=\"bpmto_ms\">
                        <h3 class=\"zci__header\">$bpm bpm in milliseconds</h3>
                        <div class=\"zci__content\">
                            <div class=\"record\">
                                <table class=\"maintable\">";
                                
    for my $i (0 .. $#note_names) {
        $html_content = $html_content .
        "<tr class=\"record\">
            <td class=\"record__cell__key record_keyspacing\">
                $note_names[$i]
            </td>
            <td class=\"record__cell__value\">
                $straight_values[$i] ms
            </td>
            <td />
            <td class=\"record__cell__key record_keyspacing\">
                Triplet
            </td>
            <td class=\"record__cell__value\">
                $triplet_values[$i] ms
            </td>
            <td />
            <td class=\"record__cell__key record_keyspacing\">
                Dotted
            </td>
            <td class=\"record__cell__value\">
                $dotted_values[$i] ms
            </td>
        </tr>";
    }
    
    $html_content = $html_content .
    "</table></div></div></div>";
    
    
    return html => $html_content,
           answer => "$bpm bpm in milliseconds
Whole Note: " . $straight_values[0] . " ms, Triplet: " . $triplet_values[0] . " ms, Dotted: " . $dotted_values[0] . " ms
Half Note: " . $straight_values[1] . " ms, Triplet: " . $triplet_values[1] . " ms, Dotted: " . $dotted_values[1] . " ms
Quarter Note: " . $straight_values[2] . " ms, Triplet: " . $triplet_values[2] . " ms, Dotted: " . $dotted_values[2] . " ms
1/8 Note: " . $straight_values[3] . " ms, Triplet: " . $triplet_values[3] . " ms, Dotted: " . $dotted_values[3] . " ms
1/16 Note: " . $straight_values[4] . " ms, Triplet: " . $triplet_values[4] . " ms, Dotted: " . $dotted_values[4] . " ms
1/32 Note: " . $straight_values[5] . " ms, Triplet: " . $triplet_values[5] . " ms, Dotted: " . $dotted_values[5] . " ms";
};

1;
