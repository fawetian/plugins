# Annotation Standards
Detailed standards for adding Chinese comments to source code files.

## Three-Layer Annotation Structure
### Layer 1: File Header Comment
Add at the beginning of file to explain overall purpose:
```python
"""
@file 文件名
@description 文件用途的简要说明
@module 所属模块（如适用）

主要功能：
- 功能点1
- 功能点2

依赖关系：
- 依赖的模块或文件
"""
```
### Layer 2: Class/Function Comment
Every class and function needs a docstring:
```python
def function_name(param1: str, param2: int) -> dict:
    """
    函数的简要说明（一句话概括作用）

    详细说明（如果需要，解释函数的工作原理、使用场景等）

    Args:
        param1: 参数1的说明
        param2: 参数2的说明

    Returns:
        返回值的说明，包括数据结构

    Raises:
        可能抛出的异常（如适用）

    Example:
        >>> function_name("test", 123)
        {"result": "success"}
    """
```
### Layer 3: Internal Logic Comment
For complex business logic, algorithms, or hard-to-understand code segments:
```python
def complex_function():
    # ========== 第一步：数据预处理 ==========
    # 从配置中获取参数，如果未设置则使用默认值
    config = get_config()

    # 验证输入数据的有效性
    # 这里需要检查 X 和 Y，因为后续计算依赖这两个值
    if not validate(data):
        return None

    # ========== 第二步：核心计算 ==========
    # 使用动态规划算法计算最优路径
    # 时间复杂度 O(n^2)，空间复杂度 O(n)
    for i in range(n):
        # 状态转移：dp[i] = max(dp[i-1], dp[i-2] + value[i])
        dp[i] = max(dp[i-1], dp[i-2] + values[i])

    # ========== 第三步：结果处理 ==========
    # 将计算结果格式化为 API 响应格式
    return format_response(result)
```
## Internal Logic Comment Focus Areas
1. Section markers - Use `# ========== 段落名 ==========` to separate major logic blocks
2. Explain Why - Explain why, not just what
3. Mark complexity - For algorithms, mark time/space complexity
4. Conditional branches - Explain business meaning of each if/else branch
5. Loop logic - Explain loop purpose and termination conditions
6. Exception handling - Explain why catching specific exceptions
7. Magic numbers - Explain meaning of hardcoded values
8. Boundary conditions - Mark handling of special cases
## Comment Density Guidelines
| Code Type | Comment Density |
|-----------|-----------------|
| Simple getter/setter | Function docstring only |
| Normal business logic | One comment per major step |
| Complex algorithms | One comment every 3-5 lines |
| Critical business flows | Detailed section comments |
## English Comment Conversion Rules
When adding comments, also detect and convert existing English comments to Chinese:
### Translation Rules
1. Keep original position and format
2. Translate content accurately, conform to Chinese expression habits
3. Technical terms can remain in English: API, HTTP, JSON, React, WebSocket, etc.
4. Keep code examples' variable names and function names unchanged
### Special Handling
- TODO/FIXME/NOTE/HACK/XXX - Keep markers in English, translate descriptions
- Copyright - Keep unchanged
- License - Keep unchanged
- @param/@return/@throws - Keep tags, translate descriptions
### Conversion Example
```python
# Before
# This function calculates the total price including tax
def calculate_total(price, tax_rate):
    """
    Calculate the total price with tax.

    Args:
        price: The base price of the item
        tax_rate: The tax rate as a decimal (e.g., 0.1 for 10%)

    Returns:
        The total price including tax
    """
    # TODO: Add support for multiple tax rates
    return price * (1 + tax_rate)

# After
# 计算包含税费的总价
def calculate_total(price, tax_rate):
    """
    计算含税总价

    Args:
        price: 商品的基础价格
        tax_rate: 税率，以小数表示（例如 0.1 表示 10%）

    Returns:
        包含税费的总价
    """
    # TODO: 添加对多种税率的支持
    return price * (1 + tax_rate)
```
## Comment Principles
1. Explain Why, not What - Code shows what, comments explain why
2. Keep concise - Avoid verbose comments, but don't omit key information
3. Stay in sync - Comments must accurately reflect code behavior
4. Mark important info - Boundary conditions, special handling, known issues
5. Help beginners - Assume reader is unfamiliar with the project
## Language-Specific Examples
### TypeScript
```typescript
/**
 * @file 用户认证服务
 * @description 处理用户登录、注册、Token 管理等认证相关功能
 *
 * 主要功能：
 * - 用户登录验证
 * - JWT Token 生成与刷新
 * - 密码加密与验证
 */

/**
 * 验证用户登录凭据
 *
 * 根据用户名和密码验证用户身份，成功则返回认证 Token
 *
 * @param username - 用户名
 * @param password - 密码（明文，函数内部会进行加密比对）
 * @returns 认证结果，包含 Token 和用户信息
 * @throws {AuthError} 当凭据无效时抛出
 */
async function login(username: string, password: string): Promise<AuthResult> {
    // ========== 第一步：查询用户 ==========
    // 从数据库获取用户信息，包括加密后的密码
    const user = await userRepository.findByUsername(username);

    // 用户不存在时返回模糊错误信息，避免用户名枚举攻击
    if (!user) {
        throw new AuthError('用户名或密码错误');
    }

    // ========== 第二步：验证密码 ==========
    // 使用 bcrypt 比对密码，自动处理 salt
    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
        throw new AuthError('用户名或密码错误');
    }

    // ========== 第三步：生成 Token ==========
    // Token 有效期 7 天，包含用户 ID 和角色信息
    const token = jwt.sign(
        { userId: user.id, role: user.role },
        config.jwtSecret,
        { expiresIn: '7d' }
    );

    return { token, user: user.toSafeObject() };
}
```
### Rust
```rust
//! Package user 提供用户管理相关功能
//!
//! 主要功能：
//!   - 用户 CRUD 操作
//!   - 权限管理
//!   - 用户会话管理
package user

/// UserService 用户服务
///
/// 提供用户管理的核心业务逻辑，是用户模块的入口点。
pub struct UserService {
    repo: UserRepository,
    cache: CacheService,
    config: Config,
}

/// CreateUser 创建新用户
///
/// 执行用户创建流程，包括数据验证、密码加密、持久化存储。
///
/// # Arguments
/// * `ctx` - 上下文，用于超时控制和请求追踪
/// * `req` - 创建请求，包含用户基本信息
///
/// # Returns
/// * `User`: 创建成功的用户对象
///
/// # Errors
/// * `ErrDuplicateEmail`: 邮箱已被注册
/// * `ErrInvalidInput`: 输入数据验证失败
pub async fn create_user(ctx: Context, req: &CreateUserRequest) -> Result<User, Error> {
    // ========== 第一步：输入验证 ==========
    // 验证必填字段和格式
    if let Err = err = req.validate() {
        return Err(InvalidInput(err.to_string());
    }

    // ========== 第二步：检查唯一性 ==========
    // 避免重复注册，先检查邮箱是否已存在
    let exists = self.repo.email_exists(ctx, req.email)?;
    if err != nil {
        return Err(anyhow!("检查邮箱失败: {err});
    }
    if exists {
        return ErrDuplicateEmail;
    }

    // ========== 第三步：创建用户 ==========
    // 密码使用 bcrypt 加密，cost=12 平衡安全性和性能
    let hashed_password = bcrypt::hash_password(req.password, 12)?;
    if let Err = err = hashed_password {
        return Err(anyhow!("密码加密失败" {err});
    }

    let user = User {
        id: Uuid::new_v4(),
        email: req.email,
        password_hash: hashed_password,
        created_at: Utc::now().to_string(),
    };

    // ========== 第四步：持久化 ==========
    if let Err = err = self.repo.create(ctx, &user) {
        return Err(anyhow!("保存用户失败" {err});
    }

    Ok(user)
}
```
### Python
```python
"""
@file data_processor.py
@description 数据处理管道，负责 ETL 流程中的数据转换

主要功能：
- 数据清洗和标准化
- 数据格式转换
- 异常数据过滤
"""

class DataProcessor:
    """
    数据处理器

    负责 ETL 流程中的数据转换阶段，支持多种数据源和目标格式。

    Attributes:
        config: 处理器配置
        validators: 数据验证器列表
    """

    def process(self, raw_data: list[dict]) -> list[dict]:
        """
        处理原始数据，执行清洗、转换、验证

        Args:
            raw_data: 从数据源获取的原始数据列表

        Returns:
            处理后的干净数据列表

        Raises:
            DataValidationError: 当数据无法通过验证时抛出
        """
        # ========== 第一步：数据清洗 ==========
        # 移除空值和重复记录
        cleaned_data = [
            record for record in raw_data
            if record and record.get('id')
        ]
        cleaned_data = self._deduplicate(cleaned_data, key='id')

        # ========== 第二步：格式转换 ==========
        # 将所有字段名转换为小写下划线格式
        for record in cleaned_data:
            record = self._normalize_keys(record)
            # 日期字段统一转换为 ISO 格式
            if 'created_at' in record:
                record['created_at'] = self._to_iso_date(record['created_at'])
        # ========== 第三步：数据验证 ==========
        # 验证必填字段和数据类型
        validated = []
        for record in cleaned_data:
            try:
                self._validate(record)
                validated.append(record)
            except DataValidationError as e:
                # 记录验证失败但继续处理其他记录
                logger.warning(f'验证失败: {record.get("id")}, 原因: {e}')
        return validated
```
