package com.kat.os.query.tdo;

public class GetQueryKeyWordOffer extends BaseQueryIdDTO<String> {
    private String keyWord;

    public GetQueryKeyWordOffer(String keyWord) {
        super(keyWord);
    }
}
