package com.cloudwithvarjosh.usermanagement.user;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository repository;

    private UserService service;

    @BeforeEach
    void setUp() {
        service = new UserService(repository);
    }

    @Test
    void createUser() {
        CreateUserRequest request = new CreateUserRequest("Varun Joshi", "VARUN@example.com");

        // The service normalizes the email before checking the repository.
        when(repository.existsByEmailIgnoreCase("varun@example.com")).thenReturn(false);

        // Return the same User object passed to save().
        when(repository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        UserResponse response = service.create(request);

        assertThat(response.name()).isEqualTo("Varun Joshi");
        assertThat(response.email()).isEqualTo("varun@example.com");
        verify(repository).save(any(User.class));
    }

    @Test
    void createUserRejectsDuplicateEmail() {
        CreateUserRequest request = new CreateUserRequest("Varun Joshi", "varun@example.com");

        when(repository.existsByEmailIgnoreCase("varun@example.com")).thenReturn(true);

        org.assertj.core.api.Assertions.assertThatThrownBy(() -> service.create(request))
                .isInstanceOf(IllegalArgumentException.class);

        verify(repository, never()).save(any(User.class));
    }

    @Test
    void updateUser() {
        java.util.UUID id = java.util.UUID.randomUUID();
        User user = new User("Old Name", "old@example.com");

        when(repository.findById(id)).thenReturn(java.util.Optional.of(user));
        when(repository.existsByEmailIgnoreCase("new@example.com")).thenReturn(false);
        when(repository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        UpdateUserRequest request = new UpdateUserRequest("New Name", "NEW@example.com");

        UserResponse response = service.update(id, request);

        assertThat(response.name()).isEqualTo("New Name");
        assertThat(response.email()).isEqualTo("new@example.com");
    }

    @Test
    void deleteUser() {
        java.util.UUID id = java.util.UUID.randomUUID();
        User user = new User("Varun Joshi", "varun@example.com");

        when(repository.findById(id)).thenReturn(java.util.Optional.of(user));

        service.delete(id);

        verify(repository).delete(user);
    }
}
