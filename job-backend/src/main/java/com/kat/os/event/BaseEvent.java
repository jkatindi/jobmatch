package com.kat.os.event;

public class BaseEvent <T>{
    private T id;

    public BaseEvent(T id) {
        this.id = id;
    }

    public T getId() {
        return id;
    }
}
