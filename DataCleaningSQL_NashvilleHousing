-- Standardize Date Format

select SaleDateConverted, convert(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)

-- Populate Property Address date

select Propertyaddress
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select a.parcelID, a.Propertyaddress, b.parcelID, b.propertyaddress, isnull(a.Propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.Propertyaddress,b.propertyaddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Indivual Colums (address, city, state)

select Propertyaddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null

select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as address
, substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as address

from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(Propertyaddress, charindex(',', Propertyaddress) +1, len(Propertyaddress))

select *
from PortfolioProject.dbo.NashvilleHousing


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


-- Another way to split address

select
parsename(replace(OwnerAddress, ',', '.'), 3)
,parsename(replace(OwnerAddress, ',', '.'), 2)
,parsename(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

-- change Y and N to YEs and No

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
From PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end



-- Remove Duplicates

with RowNumCTE As(
select *,
	ROW_NUMBER() OVER (
	partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				 UniqueID
				 ) row_num

From PortfolioProject.dbo.NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress


-- Delete Unused Columns

select *
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate
