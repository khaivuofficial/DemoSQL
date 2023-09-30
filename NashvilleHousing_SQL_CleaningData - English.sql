-- Cleaning Data in SQL Queries


SELECT *
From PortfolioProjects.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- 1) Standardize Date Format
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM PortfolioProjects.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- 2) Populate Property Address data

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, 
		b.ParcelID, b.PropertyAddress, 
		ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing AS a
JOIN PortfolioProjects.dbo.NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjects.dbo.NashvilleHousing AS a
JOIN PortfolioProjects.dbo.NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


--------------------------------------------------------------------------------------------------------------------------

-- 3) Breaking out Address into Individual Columns (Address, City, State)
-- A. PropertyAddress

SELECT PropertyAddress
FROM PortfolioProjects.dbo.NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProjects.dbo.NashvilleHousing

-- B. OwnerAddress

SELECT OwnerAddress
FROM PortfolioProjects.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortfolioProjects.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- 4) Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjects.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
END
FROM PortfolioProjects.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5) Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
	ORDER BY UniqueID) AS row_num
From PortfolioProjects.dbo.NashvilleHousing
--order by ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1

Select *
From PortfolioProjects.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate































