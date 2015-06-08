package processing.visualcube1e3.simulator;

import java.awt.*;
import java.awt.geom.Rectangle2D;
import java.io.InputStream;

import processing.core.PApplet;

import com.jogamp.opengl.util.awt.TextRenderer;

class GLTextRenderer {
	public static enum ALIGN {
		LEFT, CENTER, RIGHT
	};

	private PApplet s;
	private TextRenderer textRenderer = null;

	GLTextRenderer(PApplet sketch, String font, int size) {
		this(sketch, font, size, true, true);
	}

	GLTextRenderer(PApplet sketch, String font, int size, boolean antialiased, boolean mipmap) {
		s = sketch;

		Font f = null;
		try {
			InputStream is = getClass().getResourceAsStream(font);
			f = Font.createFont(Font.TRUETYPE_FONT, is).deriveFont((float) size);
		} catch (Exception e) {
			f = new Font("Arial", Font.TRUETYPE_FONT, size);
		}
		textRenderer = new TextRenderer(f, antialiased, true, null, mipmap);
		textRenderer.setColor(1.0f, 1.0f, 1.0f, 1.0f);
		textRenderer.setSmoothing(true);
//		textRenderer.setUseVertexArrays( true );
	}

	void print(String str, Vector2D v, ALIGN a) {
		if (textRenderer == null) return;
		Rectangle2D r = textRenderer.getBounds(str);
		Vector2D v2 = new Vector2D((a == ALIGN.CENTER) ? v.x
				- (float) r.getWidth() / 2 : (a == ALIGN.RIGHT) ? v.x
				- (float) r.getWidth() : 0, v.y + (float) r.getHeight());
		print(str, v2);
	}

	void print(String str, Vector2D v) {
		if (textRenderer == null) return;
		textRenderer.beginRendering(s.width, s.height, true);
		textRenderer.draw(str, (int) v.x, s.height - (int) v.y);
		textRenderer.endRendering();
		textRenderer.flush();
	}

	void print(String str, Vector3D v) {
		print(str, v, 1.0f);
	}

	/**
	 * Draw text at position
	 * @param str
	 * @param v
	 * @param s
	 */
	void print(String str, Vector3D v, float s) {
		if (textRenderer == null) return;
		textRenderer.begin3DRendering();
		textRenderer.draw3D(str, v.x, v.y, v.z, s);
		textRenderer.end3DRendering();
		textRenderer.flush();
	}

	/**
	 * Set text colo
	 * @param r Red value
	 * @param g Green value
	 * @param b Blue value
	 * @param a Alpha value
	 */
	void setColor(int r, int g, int b, int a) {
		if (textRenderer == null) return;
		textRenderer.setColor(r/255f, g/255f, b/255f, a/255f);
	}

	/**
	 * Get rid of resources like textures.
	 */
	public void dispose() {
		if (textRenderer == null) return;
		textRenderer.dispose();
	}

}