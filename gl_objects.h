#ifndef GL_OBJECTS_H
#define GL_OBJECTS_H

#include <optional>
#include "stdafx.h"
#include "shader_util.h"

template<typename T>
class GlBuffer {
public:
    GLenum target;
    GLuint bufferId;
    GLsizeiptr size;

    explicit GlBuffer(const GLenum target): size(0) {
        this->target = target;
        this->bufferId = 0;
        if (glIsBuffer(this->bufferId)) {
            glDeleteBuffers(1, &this->bufferId);
        }
        glGenBuffers(1, &this->bufferId);
    }

    ~GlBuffer() {
        if (glIsBuffer(this->bufferId) == GL_TRUE) {
            glDeleteBuffers(1, &this->bufferId);
        }
    }

    void bind(const std::optional<GLenum>& target = std::nullopt) const {
        glBindBuffer(target.value_or(this->target), this->bufferId);
    }

    void bindBase(const GLuint index, const std::optional<GLenum>& target = std::nullopt) const {
        glBindBufferBase(target.value_or(this->target), index, this->bufferId);
    }

    void unbind() const {
        glBindBuffer(target, 0);
    }

    void unbindBase(const GLuint index) const {
        glBindBufferBase(target, index, 0);
    }

    void uploadStorage(const void* data, const GLsizeiptr size) {
        this->size = size;
        this->bind();
        glBufferStorage(target, size, data, 0);
        this->unbind();
    }

    void uploadStorage(const std::vector<T>& data) {
        this->uploadStorage(data.data(), data.size() * sizeof(T));
    }

    [[nodiscard]] std::vector<T> downloadStorage() const {
        this->bind();

        void* rawBufferData = malloc(this->size);
        memset(rawBufferData, 0, this->size);
        glGetBufferSubData(target, 0, this->size, rawBufferData);

        T* data = static_cast<T*>(rawBufferData);
        std::vector<T> result(data, data + this->size / sizeof(T));
        free(rawBufferData);

        this->unbind();

        return result;
    }
};

class GlVertexArray {
    GLuint vao{};
    std::shared_ptr<GlBuffer<vec2> > vbo = nullptr;
    std::shared_ptr<GlBuffer<uint32_t> > ibo = nullptr;

public:
    GlVertexArray(const std::shared_ptr<GlBuffer<vec2> >& vbo,
                  const std::shared_ptr<GlBuffer<uint32_t> >& ibo) {
        if (vbo == nullptr || ibo == nullptr) {
            throw std::invalid_argument("vbo or ibo is null");
        }
        this->vbo = vbo;
        this->ibo = ibo;
        if (glIsVertexArray(this->vao) == GL_TRUE) {
            glDeleteVertexArrays(1, &this->vao);
        }
        glGenVertexArrays(1, &vao);
        this->bind();
        glEnableVertexAttribArray(0);
        vbo->bind(GL_ARRAY_BUFFER);
        glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, nullptr);
        ibo->bind(GL_ELEMENT_ARRAY_BUFFER);
        this->unbind();
        if (glGetError() != GL_NO_ERROR) {
            throw std::runtime_error("Error while creating vertex array");
        }
        vbo->unbind();
        ibo->unbind();
    }

    void bind() const {
        glBindVertexArray(this->vao);
    }

    void unbind() const {
        glBindVertexArray(0);
    }
};

// required for unit test!
class GlProgram {
    GLuint m_program;

public:
    GlProgram() {
        this->m_program = glCreateProgram();
    }

    void attachShaderSource(const GLenum type, const std::string& source) const {
        const GLuint shader = glCreateShader(type);

        const char* data = source.data();
        glShaderSource(
            shader,
            1,
            &data,
            nullptr
        );
        glCompileShader(shader);

        GLint status;
        GLsizei length;
        glGetObjectParameterivARB(shader, GL_OBJECT_COMPILE_STATUS_ARB, &status);

        if (status != GL_TRUE) {
            char errorMessage[2048];
            glGetInfoLogARB(shader, 2047, &length, errorMessage);
            const std::string errorString(errorMessage);
            std::cout << "Shader compilation error: " << std::endl;
            std::cout << errorString << std::endl << "-----------" << std::endl;

            exit(EXIT_FAILURE);
        }

        glAttachShader(this->m_program, shader);
    }

    void attachShaderFile(const GLenum type,
                          const std::string& filePath,
                          const std::map<std::string, std::string>& defines = {}) const {
        const std::string file_contents = replaceIncludesWithFileContent(filePath);
        std::stringstream ss;

        if (const auto version_pos = file_contents.find("#version"); version_pos != std::string::npos) {
            const auto version_end = file_contents.find("\n", version_pos);
            ss << file_contents.substr(version_pos, version_end - version_pos + 1);

            for (const auto& [fst, snd] : defines) {
                ss << "#define " << fst << " " << snd << "\n";
            }
            ss << file_contents.substr(version_end + 1);
        } else {
            for (const auto& [fst, snd] : defines) {
                ss << "#define " << fst << " " << snd << "\n";
            }
            ss << file_contents;
        }

        this->attachShaderSource(type, ss.str());
    }


    void link() const {
        glLinkProgram(this->m_program);

        GLint status;
        GLsizei length;
        glGetProgramiv(this->m_program, GL_LINK_STATUS, &status);

        if (status != GL_TRUE) {
            char errorMessage[2048];
            glGetProgramInfoLog(this->m_program, 2047, &length, errorMessage);

            const std::string errorString(errorMessage);
            std::cerr << "Shader Program Linking Error: " << errorString << std::endl;

            exit(EXIT_FAILURE);
        }
    }

    void bind() const {
        glUseProgram(this->m_program);
    }

    void unbind() const {
        glUseProgram(0);
    }

    GLuint programId() const {
        return this->m_program;
    }

    ~GlProgram() {
        if (glIsProgram(this->m_program) == GL_TRUE) {
            glDeleteProgram(this->m_program);
        }
    }
};

class TerrainCamera {
public:
    glm::vec3 cameraPos;
    glm::vec3 cameraFront;
    glm::vec3 cameraUp;

    float yaw;
    float pitch;
    float lastX, lastY;
    float fov; // Field of View for projection matrix
    bool firstMouse;
    bool mousePressed;

    float deltaTime;
    float lastFrame;

    float aspectRatio; // Needed for the projection matrix
    float nearPlane;
    float farPlane;

    float acceleration = 0.12f;
    float drag = 0.92f;
    vec3 velocity = vec3(0.f);

    explicit TerrainCamera(float aspectRatio, float nearPlane = 0.1f,
                           float farPlane = 10000.0f) : cameraPos(glm::vec3(5.0f, 5.0f, 0.0f)),
                                                        cameraFront(glm::vec3(0.0f, -1.f, 0.f)),
                                                        cameraUp(glm::vec3(0.0f, 0.0f, 1.0f)),
                                                        yaw(45.0f), pitch(0.0f),
                                                        lastX(400.0f), lastY(300.0f),
                                                        fov(45.0f), firstMouse(true), mousePressed(false),
                                                        deltaTime(0.0f), lastFrame(0.0f),
                                                        aspectRatio(aspectRatio), nearPlane(nearPlane),
                                                        farPlane(farPlane) {
                                                            updateFront();
    }

    void processInput(GLFWwindow* window) {
        float cameraSpeed = acceleration * deltaTime; // Adjust speed according to frame rate
        glm::vec3 cameraRight = glm::normalize(glm::cross(cameraFront, cameraUp));
        glm::vec3 cameraForwardXZ = glm::normalize(glm::vec3(cameraFront.x, cameraFront.y, 0.0));

        if (glfwGetKey(window, GLFW_KEY_J) == GLFW_PRESS)
            velocity += cameraForwardXZ * cameraSpeed;
        if (glfwGetKey(window, GLFW_KEY_K) == GLFW_PRESS)
            velocity -= cameraForwardXZ * cameraSpeed;
        if (glfwGetKey(window, GLFW_KEY_H) == GLFW_PRESS)
            velocity -= cameraRight * cameraSpeed;
        if (glfwGetKey(window, GLFW_KEY_L) == GLFW_PRESS)
            velocity += cameraRight * cameraSpeed;
        if (glfwGetKey(window, GLFW_KEY_M) == GLFW_PRESS)
            velocity -= cameraUp * cameraSpeed;
        if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_PRESS)
            velocity += cameraUp * cameraSpeed;
    }

    void updateFront() {
        glm::vec3 front;
        front.x = cos(glm::radians(yaw)) * cos(glm::radians(pitch));
        front.y = sin(glm::radians(yaw)) * cos(glm::radians(pitch));
        front.z = sin(glm::radians(pitch));
        this->cameraFront = glm::normalize(front);
    }

    void mouseCallback(GLFWwindow* window, double xpos, double ypos) {
        if (!mousePressed)
            return;

        if (firstMouse) {
            lastX = xpos;
            lastY = ypos;
            firstMouse = false;
        }

        float xOffset = xpos - lastX;
        float yOffset = lastY - ypos;
        lastX = xpos;
        lastY = ypos;

        float sensitivity = 0.1f;
        xOffset *= sensitivity;
        yOffset *= sensitivity;

        yaw -= xOffset;
        pitch += yOffset;

        if (pitch > 89.0f)
            pitch = 89.0f;
        if (pitch < -89.0f)
            pitch = -89.0f;

        this->updateFront();
    }

    void mouseButtonCallback(GLFWwindow* window, int button, int action, int mods) {
        if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_PRESS)
            mousePressed = true;
        else if (button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_RELEASE) {
            mousePressed = false;
            firstMouse = true;
        }
    }

    glm::mat4 getViewMatrix() {
        return glm::lookAt(cameraPos, cameraPos + cameraFront, cameraUp);
    }

    glm::mat4 getProjectionMatrix() {
        return glm::perspective(glm::radians(fov), aspectRatio, nearPlane, farPlane);
    }

    glm::mat4 getVPMatrix() {
        return getProjectionMatrix() * getViewMatrix();
    }

    void update() {
        float currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;

        cameraPos += velocity;
        velocity *= drag;
    }
};


#endif //GL_OBJECTS_H
