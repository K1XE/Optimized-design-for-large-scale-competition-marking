# 项目说明文档
## 2023中国研究生创新实践系列大赛
## “华为杯”第二十届中国研究生数学建模竞赛C题全国一等奖————自动化评审代码
本文档详细描述了各个文件夹及其包含的文件，以及如何在 MATLAB R2022a 环境下正确运行代码和处理数据。

---

## 文件及文件夹结构说明

### **“第一问”文件夹**
- **数据记录.txt**: 包含三种优化策略的具体指标。
- **\*.bmp**: 与文件名对应的图像文件。
- **“问题一代码”文件夹**:
  - `prob1_*.m`: 对应第 * 种优化策略的具体代码。

---

### **“第二问”文件夹**
#### **“第二问对比图象”文件夹**
- `predata_round*.m`: 对 * 阶段的数据进行预处理的函数。
- `prob2_plan*.m`: 第 * 种策略的具体代码，并具有绘制对比图的功能。
- `prob2_sort.m`: 实现四种策略的优劣排序功能。

#### **“第二问第一小问”文件夹**
- `predata_round*.m`: 对 * 阶段的数据进行预处理的函数。
- `prob2_plan*.m`: 第 * 种策略的具体代码。
- `prob2_sort.m`: 实现四种策略的优劣排序功能。

#### **“第二问优化”文件夹**
- `predata_round*.m`: 对 * 阶段的数据进行预处理的函数。
- `prob2_optim_*.m`: 第 * 种优化策略的代码。

---

### **“第三问”文件夹**
#### **“第三问成绩与极差变化”文件夹**
- `prob3_pre.m`: 进行数据统计学处理的总代码。
- **\*.bmp**: 与文件名对应的图像文件。

#### **“第三问专家评判规律”文件夹**
- `prob3_gb.m`: 对两阶段评审和不分阶段评审进行优劣比较。
- **\*.bmp**: 与文件名对应的图像文件。

#### **“第三问大极差处理策略”文件夹**
- `prob3.m`: 多元非线性拟合代码，用于处理大极差策略。
- `init_changed_Up.m`: 上调最小值的函数。
- `init_changed_Down.m`: 下调最大值的函数。
- `init_changed_total.m`: 整体拟合函数（作为对照）。

---

### **“第四问”文件夹**
- `generate_EGmatrix_round1.m`: 生成第一阶段“专家-组别”数组的函数接口。
- `generate_EGmatrix_round2.m`: 生成第二阶段“专家-组别”数组的函数接口。
- `generate_EGmatrix.m`: 同时生成两阶段“专家-组别”数组的函数接口。
- `generate_rankingExcel.m`: 生成最终排行榜的函数接口。
- `TEST.m`: 测试自动化代码的测试文件。
- `init_changed_Up.m`: 上调最小值的函数。
- `init_changed_Down.m`: 下调最大值的函数。
- `auto_step1.m`: 生成两阶段“专家-组别”数组的函数接口（即01矩阵）。
- `auto_step2.m`: 生成最终排行榜的函数接口（需先将两个 Excel 表中的 1 替换为原始分值）。

---

## 测试文件说明

运行 `TEST.m` 测试文件时，需按以下顺序传入参数：
1. 第一阶段专家总数（第一阶段不同编号的专家数）。
2. 组别总数（作品的总数）。
3. 总获奖率（1 等奖获奖率 + 2 等奖获奖率 + 3 等奖获奖率）。
4. 第二阶段专家总数（第二阶段不同编号的专家数）。

### 测试文件运行结果
- 运行后会生成两个 `.xlsx` 文件（`Expert_Group_matrix_round*.xlsx`）：
  - 分别表示第 * 阶段的“专家-组别”数组（即第 n 个专家批阅 m 个作品的情况，1 表示批阅，0 表示未批阅）。
  - 可根据表格规范将 `1` 处的值替换为原始分值。
  - 替换完成后，生成的 `Expert_Group_matrix_round*.xlsx` 文件即为两个阶段规范的原始分文件。

### 接下来的步骤
- 传入 `generate_rankingExcel.m` 函数接口后即可得到最终排行榜。

---

## 其他说明
- 测试文件生成的“专家-组别”数组中的原始分为随机生成，可根据数组规范修改内容。
- 各代码文件与 Excel 文件之间的运行依赖关系请严格按照上述说明执行，以确保结果的准确性。