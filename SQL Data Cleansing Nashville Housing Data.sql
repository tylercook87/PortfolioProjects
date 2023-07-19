SELECT *
FROM [PortfolioProject].[dbo].[NashvilleHousing]


-- Standardize Date Format to Remove Timestamp

SELECT saleDateConverted, Convert(Date,SaleDate)
FROM dbo.NashvilleHousing;

ALTER TABLE dbo.NashvilleHousing
ADD saleDateConverted Date

Update NashvilleHousing
SET saleDateConverted = CONVERT(Date, SaleDate)

-- Populate property Address data

SELECT *
FROM dbo.NashvilleHousing
--WHERE PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM dbo.NashvilleHousing
--WHERE PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',propertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',propertyAddress)+1, LEN(PropertyAddress)) as City
FROM dbo.NashvilleHousing

ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitAddress varchar(255)

UPDATE dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',propertyAddress)-1)

ALTER TABLE dbo.NashvilleHousing
ADD PropertySplitCity varchar(255)

UPDATE dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',propertyAddress)+1, LEN(PropertyAddress))


SELECT * FROM dbo.NashvilleHousing


SELECT OwnerAddress
FROM dbo.NashvilleHousing


SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitAddress varchar(255)

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitCity varchar(255)

ALTER TABLE dbo.NashvilleHousing
ADD OwnerSplitState varchar(255)


UPDATE dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'YES' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant END
FROM dbo.NashvilleHousing

UPDATE dbo.NashvilleHousing
SET SoldAsVacant = 
  CASE WHEN SoldAsVacant = 'YES' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant END

-- Remove Duplicate Values

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
FROM dbo.NashvilleHousing
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- Delete Unused Columns

SELECT * 
FROM dbo.NashvilleHousing


ALTER TABLE dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
