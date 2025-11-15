package com.kat.os.mappers;

import java.util.List;

public interface EntityMapper<D, E> {
    E toEntity(D dto);
    D toTDO(E entity);
    List<E> toEntity(List<D> dtoList);
    List<D>  toTDO(List<E> entityList);
}
