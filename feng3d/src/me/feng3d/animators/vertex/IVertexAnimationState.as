package me.feng3d.animators.vertex
{
	import me.feng3d.animators.base.states.IAnimationState;
	import me.feng3d.core.base.Geometry;

	/**
	 * Provides an interface for animation node classes that hold animation data for use in the Vertex animator class.
	 *
	 * @see away3d.animators.VertexAnimator
	 */
	public interface IVertexAnimationState extends IAnimationState
	{
		/**
		 * Returns the current geometry frame of animation in the clip based on the internal playhead position.
		 */
		function get currentGeometry():Geometry;

		/**
		 * Returns the current geometry frame of animation in the clip based on the internal playhead position.
		 */
		function get nextGeometry():Geometry;

		/**
		 * Returns a fractional value between 0 and 1 representing the blending ratio of the current playhead position
		 * between the current geometry frame (0) and next geometry frame (1) of the animation.
		 */
		function get blendWeight():Number;
	}
}
