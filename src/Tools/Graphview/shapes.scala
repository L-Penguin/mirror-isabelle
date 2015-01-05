/*  Title:      Tools/Graphview/shapes.scala
    Author:     Markus Kaiser, TU Muenchen
    Author:     Makarius

Drawable shapes.
*/

package isabelle.graphview


import isabelle._

import java.awt.{BasicStroke, Graphics2D, Shape}
import java.awt.geom.{AffineTransform, GeneralPath, Path2D, Rectangle2D, PathIterator}


object Shapes
{
  private val default_stroke =
    new BasicStroke(1, BasicStroke.CAP_BUTT, BasicStroke.JOIN_ROUND)

  object Node
  {
    def shape(m: Visualizer.Metrics, visualizer: Visualizer, node: Graph_Display.Node)
      : Rectangle2D.Double =
    {
      val p = visualizer.Coordinates.get_node(node)
      val bounds = m.string_bounds(node.toString)
      val w = bounds.getWidth + m.pad
      val h = bounds.getHeight + m.pad
      new Rectangle2D.Double((p.x - (w / 2)).floor, (p.y - (h / 2)).floor, w.ceil, h.ceil)
    }

    def paint(gfx: Graphics2D, visualizer: Visualizer, node: Graph_Display.Node)
    {
      val m = Visualizer.Metrics(gfx)
      val s = shape(m, visualizer, node)
      val c = visualizer.node_color(node)
      val bounds = m.string_bounds(node.toString)

      gfx.setColor(c.background)
      gfx.fill(s)

      gfx.setColor(c.border)
      gfx.setStroke(default_stroke)
      gfx.draw(s)

      gfx.setColor(c.foreground)
      gfx.drawString(node.toString,
        (s.getCenterX - bounds.getWidth / 2).round.toInt,
        (s.getCenterY - bounds.getHeight / 2 + m.ascent).round.toInt)
    }
  }

  object Dummy
  {
    private val identity = new AffineTransform()

    def shape(m: Visualizer.Metrics, visualizer: Visualizer): Shape =
    {
      val w = (m.space_width / 2).ceil
      new Rectangle2D.Double(- w, - w, 2 * w, 2 * w)
    }

    def paint(gfx: Graphics2D, visualizer: Visualizer): Unit =
      paint_transformed(gfx, visualizer, identity)

    def paint_transformed(gfx: Graphics2D, visualizer: Visualizer, at: AffineTransform)
    {
      val m = Visualizer.Metrics(gfx)
      val s = shape(m, visualizer)

      gfx.setStroke(default_stroke)
      gfx.setColor(visualizer.dummy_color)
      gfx.draw(at.createTransformedShape(s))
    }
  }

  object Straight_Edge
  {
    def paint(gfx: Graphics2D, visualizer: Visualizer,
      edge: Graph_Display.Edge, head: Boolean, dummies: Boolean)
    {
      val p = visualizer.Coordinates.get_node(edge._1)
      val q = visualizer.Coordinates.get_node(edge._2)
      val ds =
      {
        val a = p.y min q.y
        val b = p.y max q.y
        visualizer.Coordinates.get_dummies(edge).filter(d => a < d.y && d.y < b)
      }
      val path = new GeneralPath(Path2D.WIND_EVEN_ODD, ds.length + 2)

      path.moveTo(p.x, p.y)
      ds.foreach(d => path.lineTo(d.x, d.y))
      path.lineTo(q.x, q.y)

      if (dummies)
        ds.foreach(d =>
          Dummy.paint_transformed(gfx, visualizer, AffineTransform.getTranslateInstance(d.x, d.y)))

      gfx.setStroke(default_stroke)
      gfx.setColor(visualizer.edge_color(edge))
      gfx.draw(path)

      if (head)
        Arrow_Head.paint(gfx, path,
          visualizer.Drawer.shape(Visualizer.Metrics(gfx), edge._2))
    }
  }

  object Cardinal_Spline_Edge
  {
    private val slack = 0.1

    def paint(gfx: Graphics2D, visualizer: Visualizer,
      edge: Graph_Display.Edge, head: Boolean, dummies: Boolean)
    {
      val p = visualizer.Coordinates.get_node(edge._1)
      val q = visualizer.Coordinates.get_node(edge._2)
      val ds =
      {
        val a = p.y min q.y
        val b = p.y max q.y
        visualizer.Coordinates.get_dummies(edge).filter(d => a < d.y && d.y < b)
      }

      if (ds.isEmpty) Straight_Edge.paint(gfx, visualizer, edge, head, dummies)
      else {
        val path = new GeneralPath(Path2D.WIND_EVEN_ODD, ds.length + 2)
        path.moveTo(p.x, p.y)

        val coords = p :: ds ::: List(q)
        val dx = coords(2).x - coords(0).x
        val dy = coords(2).y - coords(0).y

        val (dx2, dy2) =
          ((dx, dy) /: coords.sliding(3)) {
            case ((dx, dy), List(l, m, r)) =>
              val dx2 = r.x - l.x
              val dy2 = r.y - l.y
              path.curveTo(
                l.x + slack * dx, l.y + slack * dy,
                m.x - slack * dx2, m.y - slack * dy2,
                m.x, m.y)
              (dx2, dy2)
          }

        val l = ds.last
        path.curveTo(
          l.x + slack * dx2, l.y + slack * dy2,
          q.x - slack * dx2, q.y - slack * dy2,
          q.x, q.y)

        if (dummies)
          ds.foreach(d =>
            Dummy.paint_transformed(gfx, visualizer, AffineTransform.getTranslateInstance(d.x, d.y)))

        gfx.setStroke(default_stroke)
        gfx.setColor(visualizer.edge_color(edge))
        gfx.draw(path)

        if (head)
          Arrow_Head.paint(gfx, path,
            visualizer.Drawer.shape(Visualizer.Metrics(gfx), edge._2))
      }
    }
  }

  object Arrow_Head
  {
    type Point = (Double, Double)

    private def position(path: GeneralPath, shape: Shape): Option[AffineTransform] =
    {
      def intersecting_line(path: GeneralPath, shape: Shape): Option[(Point, Point)] =
      {
        val i = path.getPathIterator(null, 1.0)
        val seg = Array[Double](0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        var p1 = (0.0, 0.0)
        var p2 = (0.0, 0.0)
        while (!i.isDone()) {
          i.currentSegment(seg) match {
            case PathIterator.SEG_MOVETO => p2 = (seg(0), seg(1))
            case PathIterator.SEG_LINETO =>
              p1 = p2
              p2 = (seg(0), seg(1))

              if(shape.contains(seg(0), seg(1)))
                return Some((p1, p2))
            case _ =>
          }
          i.next()
        }
        None
      }

      def binary_search(line: (Point, Point), shape: Shape): Option[AffineTransform] =
      {
        val ((fx, fy), (tx, ty)) = line
        if (shape.contains(fx, fy) == shape.contains(tx, ty))
          None
        else {
          val (dx, dy) = (fx - tx, fy - ty)
          if ((dx * dx + dy * dy) < 1.0) {
            val at = AffineTransform.getTranslateInstance(fx, fy)
            at.rotate(- (math.atan2(dx, dy) + math.Pi / 2))
            Some(at)
          }
          else {
            val (mx, my) = (fx + (tx - fx) / 2.0, fy + (ty - fy) / 2.0)
            if (shape.contains(fx, fy) == shape.contains(mx, my))
              binary_search(((mx, my), (tx, ty)), shape)
            else
              binary_search(((fx, fy), (mx, my)), shape)
          }
        }
      }

      intersecting_line(path, shape) match {
        case None => None
        case Some(line) => binary_search(line, shape)
      }
    }

    def paint(gfx: Graphics2D, path: GeneralPath, shape: Shape)
    {
      position(path, shape) match {
        case None =>
        case Some(at) =>
          val arrow = new GeneralPath(Path2D.WIND_EVEN_ODD, 3)
          arrow.moveTo(0, 0)
          arrow.lineTo(-10, 4)
          arrow.lineTo(-6, 0)
          arrow.lineTo(-10, -4)
          arrow.lineTo(0, 0)
          arrow.transform(at)
          gfx.fill(arrow)
      }
    }
  }
}