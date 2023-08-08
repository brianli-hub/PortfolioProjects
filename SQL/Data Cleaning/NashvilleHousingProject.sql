-- Cleaning Data in SQL Queries

Select *
From ProjectNashvilleHousing..NashvilleHousing

-- Standardizing Date Format
Select SaleDateConverted, convert(date,SaleDate)
From ProjectNashvilleHousing..NashvilleHousing

update ProjectNashvilleHousing..NashvilleHousing
set SaleDate = convert(date,SaleDate)

Alter Table ProjectNashvilleHousing..NashvilleHousing
Add SaleDateConverted Date;

update ProjectNashvilleHousing..NashvilleHousing
set SaleDateConverted = convert(date,SaleDate)

-- Populate Property Address Data
Select *
from ProjectNashvilleHousing..NashvilleHousing
--where propertyaddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectNashvilleHousing..NashvilleHousing as a
join ProjectNashvilleHousing..NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Updating Property address columns where it is null based on similar parcelids with different uniqueids

update a
SET PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectNashvilleHousing..NashvilleHousing as a
join ProjectNashvilleHousing..NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)
Select PropertyAddress
from ProjectNashvilleHousing..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)- 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) as Address
from ProjectNashvilleHousing..NashvilleHousing


Alter Table ProjectNashvilleHousing..NashvilleHousing
Add PropertyAddressLine Nvarchar(255);

update ProjectNashvilleHousing..NashvilleHousing
set PropertyAddressLine = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)- 1)

Alter Table ProjectNashvilleHousing..NashvilleHousing
Add PropertyAddressCity Nvarchar(255);

update ProjectNashvilleHousing..NashvilleHousing
set PropertyAddressCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))


Select OwnerAddress
from ProjectNashvilleHousing..NashvilleHousing

-- Using Parsename instead of Substring 

select 
Parsename(replace(OwnerAddress,',', '.'),3),
Parsename(replace(OwnerAddress,',', '.'),2),
Parsename(replace(OwnerAddress,',', '.'),1)
from ProjectNashvilleHousing..NashvilleHousing


Alter Table ProjectNashvilleHousing..NashvilleHousing
Add OwnerAddressLine Nvarchar(255);

update ProjectNashvilleHousing..NashvilleHousing
set OwnerAddressLine = Parsename(replace(OwnerAddress,',', '.'),3)

Alter Table ProjectNashvilleHousing..NashvilleHousing
Add OwnerAddressCity Nvarchar(255);

update ProjectNashvilleHousing..NashvilleHousing
set OwnerAddressCity = Parsename(replace(OwnerAddress,',', '.'),2)


Alter Table ProjectNashvilleHousing..NashvilleHousing
Add OwnerAddressState Nvarchar(255);

update ProjectNashvilleHousing..NashvilleHousing
set OwnerAddressState = Parsename(replace(OwnerAddress,',', '.'),1)


-- Change Y and N to Yes and No in "Sold as Vacant" field
Select distinct(soldasvacant), count(soldasvacant)
from ProjectNashvilleHousing..NashvilleHousing
group by SoldAsVacant
order by 2

Select soldasvacant,
case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End
from ProjectNashvilleHousing..NashvilleHousing

update ProjectNashvilleHousing..NashvilleHousing
set soldasvacant = case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End


-- Remove Duplicates using CTE
With RowNumberCTE as(
Select *,
	ROW_NUMBER() Over (
		Partition by ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 Order By
						UniqueID
						) as row_number
From ProjectNashvilleHousing..NashvilleHousing
)
Delete 
from RowNumberCTE
where row_number > 1


-- Delete Unused Columns
Alter Table ProjectNashvilleHousing..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Select *
from ProjectNashvilleHousing..NashvilleHousing

Alter Table ProjectNashvilleHousing..NashvilleHousing
Drop Column SaleDate