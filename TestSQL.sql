/* BÀI TẬP BUỔI 4 
Tên học viên: Nguyễn Quang Đức */

-- Câu 1: Lấy danh sách tài khoản kế toán chi phí với dấu - trong công thức
SELECT AccountDescription, AccountType, Operator
FROM DimAccount
WHERE AccountType = 'Expenditures'
AND Operator = '-'

-- Câu 2: Lấy danh sách nhà phân phối dạng Warehouse có số đt bắt đầu bằng 1 (11) và sử dụng ngân hàng có chữ Bank
SELECT ResellerName, Phone, BusinessType, BankName
FROM DimReseller
WHERE Phone LIKE '1 (11)%'
AND BusinessType = 'Warehouse'
AND BankName LIKE '%Bank' 

-- Câu 3: Lấy danh sách nhân viên nghề Technician và được tuyển từ 2007 hoặc lương <30 và bắt đầu làm việc từ 2008
SELECT FirstName, LastName, Title, HireDate, BaseRate, StartDate
FROM DimEmployee
WHERE (Title LIKE '%Technician%' AND HireDate >= '2007-01-01') 
OR (BaseRate < 30 AND StartDate >= '2008-01-01')

-- Câu 4: Lấy danh sách sản phẩm có chữ Frame trong tên và màu Đen và Size từ 50 - 60
SELECT EnglishProductName, Color, Size
FROM DimProduct
WHERE EnglishProductName LIKE '%Frame%'
AND Color = 'Black' 
AND Size BETWEEN '50' AND '60'

-- Câu 5: Lấy thông tin những khách hàng lớn tuổi hơn toàn bộ nhân viên công ty
SELECT FirstName, LastName, Gender, BirthDate
FROM DimCustomer
WHERE BirthDate < ALL(
	SELECT BirthDate
	FROM DimEmployee)

-- Câu 6: Lấy thông tin những khách hàng có đơn đạt hàng trên 2200 vào năm 2013
SELECT FirstName, LastName, Gender 
FROM DimCustomer
WHERE CustomerKey = ANY(
	SELECT CustomerKey
	FROM FactInternetSales
	WHERE YEAR(OrderDate) = 2013
	AND SalesAmount >= 2200
	GROUP BY CustomerKey
	)

/* Câu 7: Lấy danh sách nhân viên vị trí Supervisor là con trai ban Production và Quality Assurance 
được tuyển trong năm 2008 sắp xếp tăng dần theo ngày bắt đầu làm việc */
SELECT FirstName, Title, Gender, DepartmentName, HireDate, StartDate
FROM dbo.DimEmployee
WHERE Title LIKE '%Supervisor%' 
AND Gender = 'M'
AND DepartmentName IN ('Production', 'Quality Assurance') 
AND HireDate BETWEEN '2008-01-01' AND '2008-12-31' 
ORDER BY StartDate ASC

/* Câu 8: Đếm trong bảng Geography có bao nhiêu thành phố có tên bắt đầu bằng chữ SAN */
SELECT COUNT(*) FROM dbo.DimGeography WHERE City LIKE 'SAN%'

/* Câu 9: Trả bảng đếm số lượng khách hàng phân phối theo Product Line sắp xếp giảm dần */
SELECT ProductLine, COUNT(ResellerKey) as TotalReseller
FROM dbo.DimReseller 
GROUP BY ProductLine
ORDER BY TotalReseller DESC

/* Câu 10: Trả TOP 10 khách hàng có doanh thu InternetSales lớn nhất đặt hàng trong năm 2013 */
SELECT TOP(10) c.CustomerName, SUM(f.SalesAmount) as SalesAmount
FROM FactInternetSales f
JOIN (SELECT CustomerKey, CONCAT(FirstName, ' ', MiddleName, ' ', LastName) as CustomerName FROM DimCustomer ) c ON f.CustomerKey = c.CustomerKey
WHERE YEAR(OrderDate) = 2013
GROUP BY c.CustomerName
ORDER BY SalesAmount DESC


