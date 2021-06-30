﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnderSea.Model.Constants;

namespace UnderSea.Model.Models
{
    public class MudTractor : Effect
    {
        public override void ApplyEffect(Country country)
        {
            country.Production.CoralProductionMultiplier *= (1+UpgradeConstants.MudTractor);
        }

        public override void RemoveEffect(Country country)
        {
            country.Production.CoralProductionMultiplier /= (1+UpgradeConstants.MudTractor);
        }
    }
}