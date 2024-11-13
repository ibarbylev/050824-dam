Разница между one-to-many и one-to-one только в дополнительном ограничении на
уникальность поля FK.

Пример one-to-one 
(причём, допустимы значения NULL у FK, т.е. связь по FK в этом примере не обязательна) 

```
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL
);


CREATE TABLE user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_idusersusers INT NULL,  -- Можно оставить NULL, если профиль не задан
    bio TEXT,
    user_id INT UNIQUE NULL,     -- Ограничение на уникальность внешнего ключа (если не NULL, то уникальный)
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

И почти тоже самое будет для one-to-many:

```
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL
);


CREATE TABLE user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_idusersusers INT NULL,  -- Можно оставить NULL, если профиль не задан
    bio TEXT,
    user_id INT NOT NULL,         -- Ограничение на уникальность внешнего ключа отсутствует
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```
