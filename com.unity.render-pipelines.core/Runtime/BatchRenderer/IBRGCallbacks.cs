using System;
using System.Collections.Generic;
using System.Reflection;
using Unity.Collections;

namespace UnityEngine.Rendering
{
    public struct AddedMetadataDesc
    {
        public int name;
        public int sizeInVec4s;//size in vec4s
    }

    public struct BRGInternalSRPConfig
    {
        public NativeArray<AddedMetadataDesc> metadatas;
        public Material overrideMaterial;

        public static BRGInternalSRPConfig NewDefault()
        {
            return new BRGInternalSRPConfig()
            {
                overrideMaterial = null
            };
        }
    }

    public struct AddedRendererInformation
    {
        public int instanceIndex;
        public MeshFilter meshFilter;
    }

    public struct AddRendererParameters
    {
        public List<MeshRenderer> addedRenderers;
        public List<AddedRendererInformation> addedRenderersInfo;

        public NativeArray<Vector4> instanceBuffer;
        public int instanceBufferOffset;
    }

    public interface IBRGCallbacks
    {
        public BRGInternalSRPConfig GetSRPConfig();
        public void OnAddRenderers(AddRendererParameters parameters);
        public void OnRemoveRenderers(List<MeshRenderer> renderers);
    }
}
