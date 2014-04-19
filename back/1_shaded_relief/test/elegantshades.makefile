# sources:
#	http://www.imagemagick.org/script/command-line-options.php#alpha
# run:
#	$make -f elegantshades.makefile

grey_to_alpha-black: grey_to_cleaned_grey
	convert input.png -alpha copy -channel alpha -negate +channel                              output.forum.grey_yes.fx_no.png
	convert item.shades.grey_no.05pc.png -alpha copy -channel alpha -negate +channel -fx '#000' output.forum.grey_no.05pc.fx000.png
	convert item.shades.grey_no.05pc.png -alpha copy -channel alpha -negate +channel            output.forum.grey_no.05pc.fx_no.png
	convert item.shades.grey_no.10pc.png -alpha copy -channel alpha -negate +channel -fx '#000' output.forum.grey_no.10pc.fx000.png
	convert item.shades.grey_no.10pc.png -alpha copy -channel alpha -negate +channel            output.forum.grey_no.10pc.fx_no.png

grey_to_cleaned_grey:
	convert input.png -fuzz 10% -transparent "#DDDDDD" item.shades.grey_no.10pc.png
	convert input.png -fuzz 5% -transparent "#DDDDDD" item.shades.grey_no.05pc.png