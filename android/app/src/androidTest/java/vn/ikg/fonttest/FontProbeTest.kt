package vn.ikg.fonttest

import android.util.Log
import androidx.compose.ui.test.junit4.createComposeRule
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.unit.sp
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.microsoft.fluentui.theme.FluentTheme
import com.microsoft.fluentui.theme.token.AliasTokens
import com.microsoft.fluentui.theme.token.FluentAliasTokens
import com.microsoft.fluentui.theme.token.IAliasTokens
import com.microsoft.fluentui.theme.token.TokenSet
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

class IkgAliasTokens(
    private val family: FontFamily,
    private val base: AliasTokens = AliasTokens()
) : IAliasTokens by base {
    override val typography: TokenSet<FluentAliasTokens.TypographyTokens, TextStyle> =
        TokenSet { token -> base.typography[token].copy(fontFamily = family) }
}

@RunWith(AndroidJUnit4::class)
class FontProbeTest {
    @get:Rule
    val rule = createComposeRule()

    private val sample = "Thương hiệu IKG – Tiếng Việt"

    @Test
    fun probe() {
        val r = Font(R.font.bevietnampro_regular, FontWeight.W400)
        val m = Font(R.font.bevietnampro_medium, FontWeight.W500)
        val s = Font(R.font.bevietnampro_semibold, FontWeight.W600)
        val b = Font(R.font.bevietnampro_bold, FontWeight.W700)
        val full = FontFamily(r, m, s, b)
        val regularOnly = FontFamily(r)
        val results = linkedMapOf<String, String>()

        rule.setContent {
            val tm = rememberTextMeasurer()
            fun w(label: String, style: TextStyle) {
                val res = tm.measure(AnnotatedString(sample), style.copy(fontSize = 28.sp, letterSpacing = 0.sp))
                results[label] = "FONTTEST| $label | w=${res.size.width} | weight=${style.fontWeight?.weight}"
            }
            w("D400 file Regular", TextStyle(fontFamily = FontFamily(r), fontWeight = FontWeight.W400))
            w("D500 file Medium", TextStyle(fontFamily = FontFamily(m), fontWeight = FontWeight.W500))
            w("D600 file SemiBold", TextStyle(fontFamily = FontFamily(s), fontWeight = FontWeight.W600))
            w("D700 file Bold", TextStyle(fontFamily = FontFamily(b), fontWeight = FontWeight.W700))
            w("S600 RegularOnly+600", TextStyle(fontFamily = regularOnly, fontWeight = FontWeight.W600))
            w("S700 RegularOnly+700", TextStyle(fontFamily = regularOnly, fontWeight = FontWeight.W700))
            listOf(400, 500, 600, 700).forEach {
                w("FAM$it full family", TextStyle(fontFamily = full, fontWeight = FontWeight(it)))
            }
            FluentTheme(aliasTokens = IkgAliasTokens(full)) {
                val t = FluentTheme.aliasTokens.typography
                listOf(
                    FluentAliasTokens.TypographyTokens.Title1,
                    FluentAliasTokens.TypographyTokens.Title2,
                    FluentAliasTokens.TypographyTokens.Body1Strong,
                    FluentAliasTokens.TypographyTokens.Body1
                ).forEach { w("FLU ${it.name}", t[it]) }
            }
        }
        rule.waitForIdle()
        Log.i("FONTTEST", "FONTTEST| sdk=${android.os.Build.VERSION.SDK_INT}")
        results.values.forEach { Log.i("FONTTEST", it) }
    }
}