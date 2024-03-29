﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnderSea.Model.Constants;

namespace UnderSea.Model.Models
{
    public class CoralEffect : Effect
    {
        public override void ApplyEffect(Country country)
        {
            country.CountryMaterials.SingleOrDefault(cm => cm.Material.MaterialType == MaterialTypeConstants.Coral).BaseProduction += EffectConstants.CoralNumber;
        }

        public override void RemoveEffect(Country country)
        {
            country.CountryMaterials.SingleOrDefault(cm => cm.Material.MaterialType == MaterialTypeConstants.Coral).BaseProduction -= EffectConstants.CoralNumber;
        }
    }
}
