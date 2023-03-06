package com.example.gt_events.config;

import com.example.gt_events.annotation.RequireAuth;
import com.example.gt_events.entity.Account;
import com.example.gt_events.entity.Token;
import com.example.gt_events.repo.TokenRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Optional;

@Component
public class AuthenticationInterceptor implements HandlerInterceptor {
    @Autowired
    TokenRepository tokenRepository;

    public static ThreadLocal<Account> curAccount = new ThreadLocal<>();

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        String token = request.getHeader("Authorization");
        if (handler instanceof HandlerMethod handlerMethod) {
            curAccount.remove();
            RequireAuth a = handlerMethod.getMethodAnnotation(RequireAuth.class);
            if (a != null) {
                if (token != null && !token.isEmpty()) {
                    Optional<Token> result = tokenRepository.findByUuid(token);

                    if (result.isPresent()) {
                        curAccount.set(result.get().getAccount());
                        System.out.println(result.get());
                        if (!a.requireOrganizer() || curAccount.get().isOrganizer()) {
                            return true;
                        }
                    }
                }
                response.setStatus(401);
                return false;
            }
        }
        return HandlerInterceptor.super.preHandle(request, response, handler);
    }
}
