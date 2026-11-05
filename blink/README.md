# Blink

Custom font for Blink Shell (Settings → Appearance → Fonts → Custom),
JetBrains Mono Nerd Font with ligatures, hosted as a gist:

<!-- markdownlint-disable MD013 -->
<!-- The raw URL cannot wrap. -->

```text
https://gist.githubusercontent.com/tiberiuv/8e1aed0ec97b9b2dbe2d356f7ff7bba8/raw/JetBrainsMonoNFLig.css
```

<!-- markdownlint-enable MD013 -->

The CSS embeds the four TTFs as base64 (~13 MB), which is why it lives in a
gist rather than this repo's history. Source:
<https://gist.github.com/tiberiuv/8e1aed0ec97b9b2dbe2d356f7ff7bba8>.

After adding or changing the font, run `exit` at Blink's own prompt and open
a new window. Swiping the app closed in iOS is not enough: Blink restores the
old sessions with the font they started with.
