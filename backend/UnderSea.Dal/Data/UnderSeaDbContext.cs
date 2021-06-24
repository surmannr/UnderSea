﻿using IdentityServer4.EntityFramework.Options;
using Microsoft.AspNetCore.ApiAuthorization.IdentityServer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnderSea.Dal.EntityConfigurations;
using UnderSea.Model.Models;

namespace UnderSea.Dal.Data
{
    public class UnderSeaDbContext : ApiAuthorizationDbContext<User>
    {
        public DbSet<ActiveConstruction> ActiveConstructions { get; set; }
        public DbSet<Attack> Attacks { get; set; }
        public DbSet<AttackUnit> AttackUnits { get; set; }
        public DbSet<Building> Buildings { get; set; }
        public DbSet<BuildingEffect> BuildingEffects { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<CountryBuilding> CountryBuildings { get; set; }
        public DbSet<CountryUnit> CountryUnits { get; set; }
        public DbSet<CountryUpgrade> CountryUpgrades { get; set; }
        public DbSet<Effect> Effects { get; set; }
        public DbSet<Unit> Units { get; set; }
        public DbSet<Upgrade> Upgrades { get; set; }
        public DbSet<UpgradeEffect> UpgradeEffects { get; set; }
        public DbSet<ActiveUpgrading> ActiveUpgradings { get; set; }

        public UnderSeaDbContext(DbContextOptions options, IOptions<OperationalStoreOptions> operationalStoreOptions) : base(options, operationalStoreOptions)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Country>()
                .HasOne(c => c.Owner)
                .WithOne(u => u.Country);


            modelBuilder.Entity<Attack>()
                .HasOne(a => a.AttackerCountry)
                .WithMany(c => c.Attacks)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Attack>()
                .HasOne(a => a.DefenderCountry)
                .WithMany(c => c.Defenses)
                .OnDelete(DeleteBehavior.NoAction);


            modelBuilder.Entity<BuildingEffect>().HasKey(be => new { be.BuildingId, be.EffectId });
            modelBuilder.Entity<CountryUnit>().HasKey(cu => new { cu.CountryId, cu.UnitId });
            modelBuilder.Entity<CountryUpgrade>().HasKey(cu => new { cu.CountryId, cu.UpgradeId });
            modelBuilder.Entity<UpgradeEffect>().HasKey(ue => new { ue.EffectId, ue.UpgradeId });

            modelBuilder.Entity<Country>().OwnsOne(p => p.Production);
            modelBuilder.Entity<Country>().OwnsOne(p => p.FightPoint);

            modelBuilder.Entity<Effect>()
                .HasDiscriminator(e => e.EffectType)
                .HasValue<Effect>("effect_base")
                .HasValue<CoralEffect>("effect_coral")
                .HasValue<MilitaryEffect>("effect_military")
                .HasValue<PopulationEffect>("effect_population")
                .HasValue<Alchemy>("upgrade_effect_alchemy")
                .HasValue<CoralWall>("upgrade_effect_coralwall")
                .HasValue<MudCombine>("upgrade_effect_mudcombine")
                .HasValue<MudTractor>("upgrade_effect_mudtractor")
                .HasValue<SonarCanon>("upgrade_effect_sonarcannon")
                .HasValue<UnderwaterMartialArt>("upgrade_effect_martialart");

            modelBuilder.Entity<Effect>()
                .Property(e => e.EffectType)
                .HasMaxLength(200)
                .HasColumnName("effect_type");

            modelBuilder.ApplyConfiguration(new BuildingEntityConfiguration());
            modelBuilder.ApplyConfiguration(new UnitEntityConfiguration());
            modelBuilder.ApplyConfiguration(new WorldEntityConfiguration());
        }


    }
}
