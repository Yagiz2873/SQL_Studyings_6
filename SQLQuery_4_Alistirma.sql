/* 

SELECT ContactName , Country, ROW_NUMBER() OVER(ORDER BY Country) EtiketSira FROM Customers 

SELECT ContactName , Country, RANK() OVER(ORDER BY Country) EtiketSira FROM Customers 

En yüksek 2.unitprice değerini ROW_NUMBER() ile bul.

SELECT * FROM
(SELECT T1.UnitPrice, ROW_NUMBER() OVER(ORDER BY T1.UnitPrice DESC) RN FROM
(SELECT DISTINCT UnitPrice FROM [Order Details]) T1
) T2
WHERE T2.RN = 2

SELECT T1.Ayin_Son_Gunu, AVG(T1.Day_Diff) AS Ort FROM
(SELECT OrderDate, 
EOMONTH(OrderDate) Ayin_Son_Gunu, DATEDIFF(DAY,OrderDate,EOMONTH(OrderDate)) Day_Diff 
FROM Orders) T1
GROUP BY T1.Ayin_Son_Gunu
HAVING AVG(T1.Day_Diff) >12 






1997 yılındaki her bir ay için toplam miktarı (fiyat) , o ayı ve o aydan bir önceki/bir sonraki ayın fiyatını gösteren sorgu

SELECT T2.AY,LAG(T2.Toplam_Fiyat) OVER(ORDER BY T2.AY) Önceki_Ay ,T2.Toplam_Fiyat, LEAD(T2.Toplam_Fiyat) OVER(ORDER BY T2.AY) Sonraki_Ay FROM
(SELECT  MONTH(T1.OrderDate) AY, ROUND(SUM(T1.Toplam_Fiyat),0) Toplam_Fiyat   FROM
(SELECT o.OrderDate, UnitPrice*Quantity*(1-Discount) Toplam_Fiyat FROM Orders o 
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
WHERE YEAR(o.OrderDate) = 1997) T1
GROUP BY MONTH(T1.OrderDate)
) T2





SELECT COALESCE(ShipRegion,ShipCity) FROM Orders

Orders tablosunda ShipRegion bilgisi dolu ise o değeri alan, boş ise ShipCity nin ilk 3 harfini büyük yapıp boş olan değer yerine bu değeri döndüren sorgu

SELECT ShipRegion, ShipCity, UPPER(COALESCE(ShipRegion, LEFT(ShipCity,3))) NShipRegion FROM Orders





Orders tablosunda siparişlerin hangi aylarda yapıldığını ve her ayki toplam sipariş adedini bulan sorgu, DATEPART() ile ayı seç.

SELECT  DATEPART(month,O.OrderDate) AY , COUNT(O.OrderID) ADET  FROM Orders O
GROUP BY DATEPART(month,O.OrderDate) 
ORDER BY DATEPART(month,O.OrderDate)


Siparişleri, sipariş tutarına göre (freight) eşit parçalara bölün. dörtte birlik dilimlere ayırın.

SELECT OrderID, CustomerId, Freight, NTILE(4) OVER(ORDER BY Freight) Grup_No FROM Orders

SELECT T1.Grup_No, COUNT(T1.Grup_No) Adet FROM
(SELECT OrderID, CustomerId, Freight, NTILE(4) OVER(ORDER BY Freight) Grup_No FROM Orders
) T1
GROUP BY T1.Grup_No


Siparişleri, sipari tutarına göre 4 eşit parçaya ayır ve 4 eşit parçadaki değerlere göre (1,2,3,4 e göre) DUSUK,ORTA,YUKSEK,COK YUKSEK diye 
gruplanmış yeni bir sütunu tabloya ekle


SELECT OrderID, CustomerID, OrderDate, Freight, NTILE(4) OVER(ORDER BY Freight) Grup_No,
    CASE 
        WHEN NTILE(4) OVER(ORDER BY Freight) = 1 THEN 'DUSUK'
        WHEN NTILE(4) OVER(ORDER BY Freight) = 2 THEN 'ORTA'
        WHEN NTILE(4) OVER(ORDER BY Freight) = 3 THEN 'YUKSEK'
        WHEN NTILE(4) OVER(ORDER BY Freight) = 4 THEN 'COK YUKSEK' 
    END FreightQuartile
FROM Orders 


SELECT ProductID,ProductName,UnitPrice,
    CASE 
        WHEN UnitPrice <= 10 THEN 'UCUZ'
        WHEN UnitPrice > 10 AND UnitPrice <= 50 THEN 'ORTA_FIYATLI'
        WHEN UnitPrice > 50 THEN 'PAHALI' 
    END UnitPriceQuartile
FROM Products
ORDER BY UnitPrice 


Customers tablosunda Adres bilgilerinin başına 'Adres: ' stringini ekleyip yeni adres sütunu oluştur.

SELECT C.ContactName, C.Address, STUFF(C.Address,1,0,'Adres: ') ModifiedAdress FROM Customers C



*/
WITH EmployeeCTE AS
(SELECT EmployeeID CALISAN, YEAR(OrderDate) YIL, SUM(Freight) YIL_CIRO FROM Orders
GROUP BY EmployeeID, YEAR(OrderDate))


SELECT CALISAN, CONVERT(int,SUM(YIL_CIRO)) CIRO
FROM EmployeeCTE
GROUP BY CALISAN 













