package com.kat.os.query.tdo;

public class BaseQueryIdDTO<T> {
    private T id;
    public BaseQueryIdDTO(T id){
        this.id=id;
    }

    public T getId() {
        return id;
    }
}
