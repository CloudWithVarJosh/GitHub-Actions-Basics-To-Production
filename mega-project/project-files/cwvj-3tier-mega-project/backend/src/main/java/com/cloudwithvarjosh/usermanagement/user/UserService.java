package com.cloudwithvarjosh.usermanagement.user;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Locale;
import java.util.UUID;

@Service
@Transactional
public class UserService {

    private final UserRepository repository;

    public UserService(UserRepository repository) {
        this.repository = repository;
    }

    @Transactional(readOnly = true)
    public List<UserResponse> findAll() {
        return repository.findAll().stream()
                .map(UserResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public UserResponse findById(UUID id) {
        return UserResponse.from(findUser(id));
    }

    public UserResponse create(CreateUserRequest request) {
        String normalizedEmail = normalizeEmail(request.getEmail());

        if (repository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new IllegalArgumentException("A user with this email already exists");
        }

        User user = new User(request.getName().trim(), normalizedEmail);
        return UserResponse.from(repository.save(user));
    }

    public UserResponse update(UUID id, UpdateUserRequest request) {
        User user = findUser(id);
        String normalizedEmail = normalizeEmail(request.getEmail());

        if (!user.getEmail().equalsIgnoreCase(normalizedEmail)
                && repository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new IllegalArgumentException("A user with this email already exists");
        }

        user.update(request.getName().trim(), normalizedEmail);
        return UserResponse.from(repository.save(user));
    }

    public void delete(UUID id) {
        User user = findUser(id);
        repository.delete(user);
    }

    private User findUser(UUID id) {
        return repository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));
    }

    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
