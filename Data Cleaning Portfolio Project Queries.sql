/*

Cleaning Data in SQL Queries

*/

select *
from [Nashville ]



-- Standardize Date Format
ALTER TABLE Nashville
Add SaleDateConverted Date;
Update [Nashville ]
SET SaleDateConverted = SaleDate



-- Populate Property Address data
select *
from [Nashville ]
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville ] a
join [Nashville ] b 
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville ] a
join [Nashville ] b 
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)
select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) AS street,
       SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS City
from [Nashville ]

ALTER TABLE [Nashville ]
Add PropertySplitAddress Nvarchar(255);
Update [Nashville ]
Set PropertySplitAddress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)


ALTER TABLE [Nashville ]
Add PropertySplitCity Nvarchar(255);
Update [Nashville ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select OwnerAddress
from [Nashville ]


Select
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from [Nashville ]

Alter Table [Nashville ]
Add OwnerSplitAddress Nvarchar(255);
Update [Nashville ]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter table [Nashville ]
 Add OwnerSplitCity Nvarchar(255);
 Update  [Nashville ]
 Set  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

 Alter table [Nashville ]
 Add OwnerSplitState Nvarchar(255);
 Update [Nashville ]
 Set  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

 select * 
 from [Nashville ]



 -- Change Y and N to Yes and No in "Sold as Vacant" field
select Distinct(SoldAsVacant), COUNT(soldAsVacant)
from [Nashville ]
Group by SoldAsVacant


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from [Nashville ]

Update [Nashville ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END





-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Nashville ]
--order by ParcelID
)
select * 
From RowNumCTE
Where row_num > 1





-- Delete Unused Columns
Select *
From [Nashville ]


ALTER TABLE [Nashville ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate