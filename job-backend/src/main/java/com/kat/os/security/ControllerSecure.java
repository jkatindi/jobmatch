package com.kat.os.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationDetailsSource;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.web.bind.annotation.*;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class ControllerSecure {
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private JwtEncoder jwtEncoder;
    @GetMapping("/auth/profile")
    public Authentication  authentication(Authentication authentication){
        return  authentication;
    }
    @PostMapping("/auth/login")
    public Map<String,String> login(String username,String password){
        Authentication authentication=authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(username,password)
        );
        Instant instant=Instant.now();
        String scope=authentication.getAuthorities().stream()
                .map(a->a.getAuthority()).collect(Collectors.joining(" "));

        JwtClaimsSet jwtClaimsSet=JwtClaimsSet.builder()
                .issuedAt(instant)
                .expiresAt(instant.plus(1, ChronoUnit.HOURS))
                .subject(username)
                .claim("scope",scope)
                .build();

        JwtEncoderParameters jwtEncoderParameters=JwtEncoderParameters
                .from(JwsHeader.with(MacAlgorithm.HS512).build(),jwtClaimsSet);
        String jwt=jwtEncoder.encode(jwtEncoderParameters).getTokenValue();
        return  Map.of("access-token",jwt);
    }
}
