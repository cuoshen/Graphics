#ifndef VISIBILITY_PASS_HLSL
#define VISIBILITY_PASS_HLSL


#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VaryingMesh.hlsl"

void ApplyVertexModification(AttributesMesh input, float3 normalWS, inout float3 positionRWS, float3 timeParameters)
{
}

#include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/VertMesh.hlsl"

CBUFFER_START(UnityPerMaterial)
    float4 _VisBufferInstanceData;
CBUFFER_END

#if defined(UNITY_DOTS_INSTANCING_ENABLED)
UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
    UNITY_DOTS_INSTANCED_PROP(float4, _VisBufferInstanceData)
UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)

#define _VisBufferInstanceData UNITY_ACCESS_DOTS_INSTANCED_PROP_WITH_DEFAULT(float4, _VisBufferInstanceData)

#endif

struct GeoPoolInput
{
    uint vertId : SV_VertexID;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct VisibilityVtoP
{
    float4 pos : SV_Position;
    
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

VisibilityVtoP Vert(AttributesMesh inputMesh)
{
    VisibilityVtoP v2p;

    UNITY_SETUP_INSTANCE_ID(inputMesh);
    UNITY_TRANSFER_INSTANCE_ID(inputMesh, v2p);

    #ifdef VISIBILITY_USE_ORIGINAL_MESH

    VaryingsMeshToPS vmesh = VertMesh(inputMesh);
    v2p.pos = vmesh.positionCS;

    #else

    float2 coord = float2((input.vertId & 1) ? -0.2 : 0.2, (input.vertId & 2) ? 0.2 : -0.2);
    v2p.pos = float4(coord.x, coord.y, 0, 1);

    #endif

    return v2p;
}

void Frag(VisibilityVtoP packedInput, out float4 outVisibility : SV_Target0)
{
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
    UNITY_SETUP_INSTANCE_ID(packedInput);
    #ifdef DOTS_INSTANCING_ON
        outVisibility = _VisBufferInstanceData;
    #else
        outVisibility = float4(1, 0, 0, 0);
    #endif
}

#endif
