
CREATE PROCEDURE GetOrderDetails
 @OrderID INT
AS
BEGIN
    SELECT
        OD.ProductID,
        P.ProductName,
        OD.UnitPrice,
        OD.Quantity,
        OD.UnitPrice * OD.Quantity AS LineTotal
    FROM
        OrderDetails OD
    JOIN
        Products P ON OD.ProductID = P.ProductID
    WHERE
        OD.OrderID = @OrderID;

    SELECT
        ProductID,
        ProductName,
        UnitPrice,
        Quantity,
        LineTotal,
        SUM(LineTotal) OVER () AS TotalAmount
    FROM
        (SELECT
             OD.ProductID,
             P.ProductName,
             OD.UnitPrice,
             OD.Quantity,
             OD.UnitPrice * OD.Quantity AS LineTotal
         FROM
             OrderDetails OD
         JOIN
             Products P ON OD.ProductID = P.ProductID
         WHERE
             OD.OrderID = @OrderID) AS DerivedTable;
END;


