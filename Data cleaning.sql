select *
from NashvilleHousing

----------------------------------------------------------------------------------------
-- Standardize Date Format

select SaleDate, convert(date, SaleDate)
from NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, SaleDate)

Alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)

select SaleDateConverted, convert(date, SaleDate)
from NashvilleHousing

--------------------------------------------------------------------------
-- populate property adress data


select *
from NashvilleHousing
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

update a 
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-------------------------------------------------------------------------------
--breaking out adress into individual column (Adress, City, States)
select 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Adress,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) as AdressCity 
from NashvilleHousing


--alter table NashvilleHousing
--add PropertySplitAddress nvarchar (255);

--update NashvilleHousing
--set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitAddresses nvarchar (255);

update NashvilleHousing
set PropertySplitAddresses = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar (255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))

select *
from NashvilleHousing



select OwnerAddress
from NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from NashvilleHousing

alter table NashvilleHousing
add OwenerAdress nvarchar (255)

update NashvilleHousing
set OwenerAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


alter table NashvilleHousing
add OwnerCity nvarchar (255)

update NashvilleHousing
set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


alter table NashvilleHousing
add OwnerState nvarchar (255)

update NashvilleHousing
set OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from NashvilleHousing

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant


select soldasvacant,
case when SoldAsVacant  = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant  = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from NashvilleHousing

-------------------------------------------------------------------
--Remove Duplicate
with RowNumCTE as (

select *,
Row_number() over (
partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by
				uniqueID
				) row_num

from NashvilleHousing
)

select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

---------------------------------------------------------------------------------------------
--delete unused column

select *
from NashvilleHousing

alter table NashvilleHousing
drop column propertyaddress, owneraddress, propertysplitaddress


alter table NashvilleHousing
drop column saledate, taxdistrict