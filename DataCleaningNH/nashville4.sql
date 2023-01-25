

select * 
from PortofolioProject.dbo.NashvilleHousing2

--populating PropertyAddress
Select ParcelID, count(PropertyAddress), PropertyAddress
from PortofolioProject.dbo.NashvilleHousing2
group by PropertyAddress, ParcelID
having count(PropertyAddress) >2


select a.ParcelID, a. PropertyAddress, a.UniqueID, b.UniqueID, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortofolioProject.dbo.NashvilleHousing2 a
join PortofolioProject.dbo.NashvilleHousing2 b
on a.ParcelID=b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortofolioProject.dbo.NashvilleHousing2 a
join PortofolioProject.dbo.NashvilleHousing2 b
on a.ParcelID=b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


select PropertyAddress
from PortofolioProject.dbo.NashvilleHousing2

--Seperate propertyaddress
Alter table PortofolioProject.dbo.NashvilleHousing2
add PropertyAddressNew nvarchar(255), PropertyAddressCity nvarchar(255)

select PropertyAddress, 
SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress)-1), 
SUBSTRING(PropertyAddress, charindex(',',PropertyAddress)+1,len(PropertyAddress))
from PortofolioProject.dbo.NashvilleHousing2

update a
set PropertyAddressNew = SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress)-1), 
PropertyAddressCity = SUBSTRING(PropertyAddress, charindex(',',PropertyAddress)+1,len(PropertyAddress))
from PortofolioProject.dbo.NashvilleHousing2 a

--Seperate owneraddress
select PropertyAddress, PropertyAddressNew, PropertyAddressCity
from PortofolioProject.dbo.NashvilleHousing2

select PARSENAME(replace(OwnerAddressOld, ',','.'), 2)
from PortofolioProject.dbo.NashvilleHousing2 a


alter table PortofolioProject.dbo.NashvilleHousing2
add OwnerAddressNew nvarchar(255), OwnerAddressCity nvarchar(255)

alter table PortofolioProject.dbo.NashvilleHousing2
add OwnerAddressOld nvarchar(255)

alter table PortofolioProject.dbo.NashvilleHousing2
drop column OwnerAddressNew

update a
set OwnerAddressOld = OwnerAddress
from PortofolioProject.dbo.NashvilleHousing2 a

update a
set OwnerAddress = PARSENAME(replace(OwnerAddress, ',','.'), 3)
from PortofolioProject.dbo.NashvilleHousing2 a

update a
set OwnerAddressCity = PARSENAME(replace(OwnerAddressOld, ',','.'), 2)
from PortofolioProject.dbo.NashvilleHousing2 a

--filling owneraddress
select * 
from PortofolioProject.dbo.NashvilleHousing2

select count(*)
from PortofolioProject.dbo.NashvilleHousing2 a
where OwnerAddress is null

update a
set OwnerAddress = PropertyAddressCity
from PortofolioProject.dbo.NashvilleHousing2 a
where OwnerAddress is null

--replace the value of SoldAsVacant
Select SoldAsVacant, count(SoldAsVacant)
from PortofolioProject.dbo.NashvilleHousing2 a
group by SoldAsVacant

select SoldAsVacant, case when SoldAsVacant='N' then 'No' when SoldAsVacant='Y' then 'Yes' else SoldAsVacant end
from PortofolioProject.dbo.NashvilleHousing2 a

update a
set SoldAsVacant = case when SoldAsVacant='N' then 'No' when SoldAsVacant='Y' then 'Yes' else SoldAsVacant end
from PortofolioProject.dbo.NashvilleHousing2 a

--remove the duplicate
with acte as(
select *,
row_number() over(partition by 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		order by UniqueID) row_num

from PortofolioProject.dbo.NashvilleHousing2 a
)
select * 
from acte
where row_num = 1

delete
from acte
where row_num>1

select * 
from acte
where row_num >1


