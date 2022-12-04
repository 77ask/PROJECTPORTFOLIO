--cleaning data

SELECT *
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

--standardise date format

SELECT SaleDate,CONVERT (date,SaleDate)
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

--populate property address

SELECT *
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]
--WHERE PropertyAddress is Null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [SQL PROJECTS].[dbo].[NashvilleHousing] a
JOIN [SQL PROJECTS].[dbo].[NashvilleHousing] b
     on a.ParcelID =b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [SQL PROJECTS].[dbo].[NashvilleHousing] a
JOIN [SQL PROJECTS].[dbo].[NashvilleHousing] b
     on a.ParcelID =b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is Null

--Breaking out address into Individual columns (Adress, City, State)

SELECT PropertyAddress
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as address
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]


ALTER Table [SQL PROJECTS].[dbo].[NashvilleHousing]
add PropertySplitAddress nvarchar (255);

UPDATE [SQL PROJECTS].[dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER Table [SQL PROJECTS].[dbo].[NashvilleHousing]
add PropertySplitCity nvarchar (255);

UPDATE [SQL PROJECTS].[dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 

SELECT *
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

SELECT OwnerAddress
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

SELECT 
PARSENAME(REPLACE (OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE (OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE (OwnerAddress, ',','.'),1)
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]


ALTER Table [SQL PROJECTS].[dbo].[NashvilleHousing]
add OwnerSplitAddress nvarchar (255);

UPDATE [SQL PROJECTS].[dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress, ',','.'),3)


ALTER Table [SQL PROJECTS].[dbo].[NashvilleHousing]
add OwnerSplitCity nvarchar (255);

UPDATE [SQL PROJECTS].[dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress, ',','.'),2)


ALTER Table [SQL PROJECTS].[dbo].[NashvilleHousing]
add OwnerSplitState nvarchar (255);

UPDATE [SQL PROJECTS].[dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress, ',','.'),1)


SELECT *
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

==Change Y and N to Yes and No in "SoldAsVacant' field

SELECT Distinct(SoldAsVacant),count(SoldAsVacant)
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]
Group BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
,case When SoldAsvacant= 'Y'Then 'Yes'
      When SoldAsVacant= 'N' Then 'No'
	  ELSE SoldAsVacant
	  END
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

UPDATE  [SQL PROJECTS].[dbo].[NashvilleHousing]
SET SoldAsVacant = case When SoldAsvacant= 'Y'Then 'Yes'
      When SoldAsVacant= 'N' Then 'No'
	  ELSE SoldAsVacant
	  END

-- Remove duplicates
WITH RownumCTE AS(
SELECT *,
   Row_Number() Over(
   Partition By ParcelID,
                PropertyAddress,
				SalePrice,
				Saledate,
				LegalReference
				 ORDER BY
				  uniqueID
				  ) row_num
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]
)
--ORDER BY ParcelID
SELECT *
FROM RownumCTE
WHERE row_num >1
--ORDER BY PropertyAddress

--Delete unused columns

SELECT *
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]

ALTER Table [SQL PROJECTS].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


SELECT*
FROM [SQL PROJECTS].[dbo].[NashvilleHousing]