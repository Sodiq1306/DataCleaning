
/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject1..NationalHousing


select SaleDateConverted, CONVERT(Date,SaleDate) 
from PortfolioProject1..NationalHousing

Update NationalHousing
set SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NationalHousing
add SaleDateConverted Date;

Update NationalHousing
set SaleDateConverted = CONVERT(Date,SaleDate)


--	Populate property address date

select *
from PortfolioProject1..NationalHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1..NationalHousing a
join PortfolioProject1..NationalHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1..NationalHousing a
join PortfolioProject1..NationalHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL



-- Breaking out Address into individual columns (Address, city, state)

select PropertyAddress
from PortfolioProject1..NationalHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address

from PortfolioProject1..NationalHousing


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortfolioProject1..NationalHousing


ALTER TABLE NationalHousing
add PropertySplitAddress nvarchar(255);

Update NationalHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 



ALTER TABLE NationalHousing
add PropertySplitCity nvarchar(255);

Update NationalHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *

from PortfolioProject1..NationalHousing


select OwnerAddress
from PortfolioProject1..NationalHousing

select
PARSENAME(replace(OwnerAddress, ',', '.'), 1),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 3)

from PortfolioProject1..NationalHousing


select
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)

from PortfolioProject1..NationalHousing



ALTER TABLE NationalHousing
add OwnerSplitAddress nvarchar(255);

Update NationalHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NationalHousing
add OwnerSplitCity nvarchar(255);

Update NationalHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)



ALTER TABLE NationalHousing
add OwnerSplitState nvarchar(255);

Update NationalHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)  



select *
from PortfolioProject1..NationalHousing




-- Change Y and X to Yes and No in ;Sold As Vacant; field


select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject1..NationalHousing
Group by SoldAsVacant
ORDER BY 2


Select SoldAsVacant,
CASE
    When SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
from PortfolioProject1..NationalHousing 


update NationalHousing
set SoldAsVacant = 
CASE
    When SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
from PortfolioProject1..NationalHousing 





-- Remove Duplications 

select *,
 row_number() over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY UniqueID
			  )
			  row_num

 from PortfolioProject1..NationalHousing 
 order by ParcelID


 WITH RowNumCTE as (
 select *,
 row_number() over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY UniqueID
			  )
			  row_num

 from PortfolioProject1..NationalHousing 
 --order by ParcelID
 )
 select *
from RowNumCTE
where row_num > 1
order by PropertyAddress


WITH RowNumCTE as (
 select *,
 row_number() over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  ORDER BY UniqueID
			  )
			  row_num

 from PortfolioProject1..NationalHousing 
 --order by ParcelID
 )
 delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress






-- Delete Unused Columns


select *
from PortfolioProject1..NationalHousing

alter table PortfolioProject1..NationalHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject1..NationalHousing
drop column SaleDate









