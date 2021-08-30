#ifndef ALIGNED_SYSTEM_CAPACITY
#error Make sure that VFXGlobalInclude is pasted before VFXInstancing.hlsl is included
#endif

struct VFXIndices
{
    uint id;
    uint instanceIndex;
    uint particleIndex;
    uint index;
};

uint GetIndexInInstance(uint threadId, uint instanceIndex, uint nbMax)
{
    return threadId - instanceIndex * nbMax;
}

uint GetIndexInAttributeBuffer(uint instanceIndex, uint indexInInstance, uint alignedSystemCapacity)
{
    return instanceIndex * alignedSystemCapacity + indexInInstance;
} //current "index"

uint GetInstanceIndexFromGroupID(uint3 groupId,uint nbThreadPerGroup, uint dispatchWidth, uint alignedSystemCapacity)
{
    return (groupId.x + dispatchWidth * groupId.y) * nbThreadPerGroup / alignedSystemCapacity;
}

void VFXSetComputeInstancingIndices(
                            uint nbParticlesPerInstance,
                            uint3 groupId,
                            uint nbThreadPerGroup,
                            uint dispatchWidth,
                            #if VFX_INSTANCING_INDIRECTION
                            StructuredBuffer<uint> indirectionBufferInstances,
                            #endif
                            uint alignedSystemCapacity,
                            inout uint index,
                            inout uint particleIndex
                            )
{
    uint instanceIndex = GetInstanceIndexFromGroupID(groupId, nbThreadPerGroup, dispatchWidth, alignedSystemCapacity);
    particleIndex = index - instanceIndex * nbParticlesPerInstance;
    #if VFX_INSTANCING_INDIRECTION
        instanceIndex = indirectionBufferInstances[instanceIndex];
    #endif
    index = GetIndexInAttributeBuffer(instanceIndex, particleIndex,alignedSystemCapacity);
}


void VFXSetOutputInstancingIndices(
                            #if VFX_INSTANCING_VARIABLE_SIZE
                            uint nbInstancesInDispatch,
                            StructuredBuffer<uint> prefixSumInstances,
                            #else
                            uint nbParticlesPerInstance,
                            #endif
                            #if VFX_INSTANCING_INDIRECTION
                            StructuredBuffer<uint> indirectionBufferInstances,
                            #endif
                            uint alignedSystemCapacity,
                            inout uint index,
                            inout uint particleIndex
                            )
{
    uint instanceIndex;
    #if VFX_INSTANCING_VARIABLE_SIZE
        particleIndex = BinarySearchPrefixSum(index, prefixSumInstances, nbInstancesInDispatch,instanceIndex);
        #if VFX_INSTANCING_INDIRECTION
            instanceIndex = indirectionBufferInstances[instanceIndex];
        #endif
    #else
        instanceIndex = index / nbParticlesPerInstance;
        particleIndex = index - instanceIndex * nbParticlesPerInstance;
        #if VFX_INSTANCING_INDIRECTION
            instanceIndex = indirectionBufferInstances[instanceIndex];
        #endif
    #endif
    index = GetIndexInAttributeBuffer(instanceIndex, particleIndex,alignedSystemCapacity);
}
