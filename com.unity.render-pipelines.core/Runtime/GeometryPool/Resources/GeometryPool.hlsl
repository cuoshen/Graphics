#ifndef GEOMETRY_POOL_H
#define GEOMETRY_POOL_H

#include "Packages/com.unity.render-pipelines.core/Runtime/GeometryPool/Resources/GeometryPoolDefs.cs.hlsl"

void StoreVertex(
    int vertexIndex,
    in GeometryPoolVertex vertex,
    int vertexFlags,
    int outputBufferSize,
    RWByteAddressBuffer output)
{
    int componentOffset = outputBufferSize * GEO_POOL_POS_BYTE_OFFSET;
    output.Store3(componentOffset + vertexIndex * GEO_POOL_POS_BYTE_SIZE, asuint(vertex.pos));

    componentOffset = outputBufferSize * GEO_POOL_UV0BYTE_OFFSET;
    output.Store2(componentOffset + vertexIndex * GEO_POOL_UV0BYTE_SIZE, asuint(vertex.uv));

    componentOffset = outputBufferSize * GEO_POOL_UV1BYTE_OFFSET;
    if ((vertexFlags & GEOPOOLINPUTFLAGS_HAS_UV1) != 0)
        output.Store2(componentOffset + vertexIndex * GEO_POOL_UV1BYTE_SIZE, asuint(vertex.uv1));

    componentOffset = outputBufferSize * GEO_POOL_NORMAL_BYTE_OFFSET;
    output.Store3(componentOffset + vertexIndex * GEO_POOL_NORMAL_BYTE_SIZE, asuint(vertex.N));

    componentOffset = outputBufferSize * GEO_POOL_TANGENT_BYTE_OFFSET;
    if ((vertexFlags & GEOPOOLINPUTFLAGS_HAS_TANGENT) != 0)
        output.Store3(componentOffset + vertexIndex * GEO_POOL_TANGENT_BYTE_SIZE, asuint(vertex.T));
}

#endif
