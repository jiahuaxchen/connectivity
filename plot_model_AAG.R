plot_model(model_results_all[[1]],
            show.p =TRUE,show.values=TRUE,
            show.legend = FALSE,
            #m.labels = c("Destination Analysis-LS", "Graph Analysis-B", "Graph Analysis-LS"),
            axis.labels = c("Connectivity score"),
            rm.terms = c("are_km2", "slope","pp_dn_2","phisp",
                         "incm_md","unmplyd","fem_prc","vtrns_p","wht_prc")) +
  theme(text = element_text(size = 12)) +
  ggtitle("DA_LS") +
  geom_hline(linetype = "dotted", yintercept = 1, color = "#d95f02") +
  theme_sjplot()

plot_model(model_results_all[[2]], type="est",
            show.p =TRUE,show.values=TRUE,
            show.legend = FALSE,
            #m.labels = c("Destination Analysis-LS", "Graph Analysis-B", "Graph Analysis-LS"),
            axis.labels = c("network coverage","complexity"),
            rm.terms = c("b_gamma","b_net_dens","b_int_dens","are_km2", "slope","pp_dn_2","phisp",
                         "incm_md","unmplyd","fem_prc","vtrns_p","wht_prc"
                         )) + 
  theme(text = element_text(size = 12)) +
  ggtitle("GA_B") +
  geom_hline(linetype = "dotted", yintercept = 1, color = "#d95f02") +
  theme_sjplot()


plot_model(model_results_all[[3]],
            show.p =TRUE,show.values=TRUE,
            show.legend = FALSE,
            #m.labels = c("Destination Analysis-LS", "Graph Analysis-B", "Graph Analysis-LS"),
            axis.labels = c("complexity",
                            "network coverage","network density"),
            rm.terms = c("are_km2", "slope","pp_dn_2","phisp","incm_md","unmplyd","fem_prc","vtrns_p","wht_prc")) + 
  theme(text = element_text(size = 12)) +
  ggtitle("GA_LS") +
  geom_hline(linetype = "dotted", yintercept = 1, color = "#d95f02") 
