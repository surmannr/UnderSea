﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnderSea.Model.Constants;

namespace UnderSea.Model.Models
{
    public class MudCombine : Effect 
    {
        public override void ApplyEffect(Country country)
        {
            country.CountryMaterials
                .SingleOrDefault(cm => cm.Material.MaterialType == MaterialTypeConstants.Coral).Multiplier *= (1+UpgradeConstants.MudCombine);
        }

        public override void RemoveEffect(Country country)
        {
            country.CountryMaterials
                .SingleOrDefault(cm => cm.Material.MaterialType == MaterialTypeConstants.Coral).Multiplier /= (1+UpgradeConstants.MudCombine);
        }
    }
}
