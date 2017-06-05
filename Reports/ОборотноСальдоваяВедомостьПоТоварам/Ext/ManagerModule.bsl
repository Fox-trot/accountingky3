﻿ #Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru = 'Оборотно - сальдовая ведомость ТМЗ'");
	
	// Скрытие варианта отчета настройкой администратора.
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Обороты");
	НастройкиВарианта.Описание = НСтр("ru = 'Обороты'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Истина;
	
	// Скрытие варианта отчета настройкой разработчика.
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Остатки");
	НастройкиВарианта.Описание = НСтр("ru = 'Остатки'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	
	// Скрытие варианта отчета настройкой разработчика.
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Приход");
	НастройкиВарианта.Описание = НСтр("ru = 'Приход'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	
	// Скрытие варианта отчета настройкой разработчика.
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Расход");
	НастройкиВарианта.Описание = НСтр("ru = 'Расход'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	
	// Скрытие варианта отчета настройкой разработчика.
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОСВ общая");
	НастройкиВарианта.Описание = НСтр("ru = 'ОСВ общая'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли