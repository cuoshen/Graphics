namespace UnityEngine.Rendering.HighDefinition
{
    [GenerateHLSL(@"Runtime\Lighting\ScreenSpaceLighting\ShaderVariablesAmbientOcclusion.cs.hlsl",
        needAccessors = false, generateCBuffer = true)]
    internal struct ShaderVariablesAmbientOcclusion
    {
        public Vector4 _AOBufferSize;
        public Vector4 _AOParams0;
        public Vector4 _AOParams1;
        public Vector4 _AOParams2;
        public Vector4 _AOParams3;
        public Vector4 _AOParams4;
        public Vector4 _FirstTwoDepthMipOffsets;
        public Vector4 _AODepthToViewParams;
    }
}
