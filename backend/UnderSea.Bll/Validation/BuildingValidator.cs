﻿using FluentValidation;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnderSea.Bll.Dtos;
using UnderSea.Dal.Data;

namespace UnderSea.Bll.Validation
{
    public class BuildingValidator : AbstractValidator<BuyBuildingDto>
    {
        private readonly UnderSeaDbContext _context;

        public BuildingValidator(UnderSeaDbContext context)
        {
            this._context = context;
            RuleFor(building => building.BuildingId).NotNull().MustAsync(async (buildingId, cancellation) =>await BuildingExist(buildingId));
        }

        private async Task<bool> BuildingExist(int buildingId) 
            => await _context.Buildings.Where(b => b.Id == buildingId).AnyAsync();
    }
}
