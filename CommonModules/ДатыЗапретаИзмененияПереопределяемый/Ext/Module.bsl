﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет изменить работу интерфейса при встраивании.
//
// Параметры:
//  НастройкиРаботыИнтерфейса - Структура - содержит свойство:
//   * ИспользоватьВнешнихПользователей - Булево - начальное значение Ложь,
//     если установить Истина, тогда даты запрета можно будет настраивать для внешних пользователей.
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	
	
КонецПроцедуры

// Заполняет разделы дат запрета изменения, используемые при настройке дат запрета.
// Если не указать ни одного раздела, тогда будет доступна только настройка общей даты запрета.
//
// Параметры:
//  Разделы - ТаблицаЗначений - с колонками:
//   * Имя - Строка - имя, используемое в описании источников данных в
//       процедуре ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
//
//   * Идентификатор - УникальныйИдентификатор - идентификатор ссылки элемента плана видов характеристик.
//       Чтобы получить идентификатор, нужно в режиме 1С:Предприятие выполнить метод платформы:
//       "ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПолучитьСсылку().УникальныйИдентификатор()".
//       Не следует указывать идентификаторы, полученные любым другим способом,
//       так как это может нарушить их уникальность.
//
//   * Представление - Строка - представляет раздел в форме настройки дат запрета.
//
//   * ТипыОбъектов  - Массив - типы ссылок объектов, в разрезе которых можно настроить даты запрета,
//       например Тип("СправочникСсылка.Организации"); если не указано ни одного типа,
//       то даты запрета будут настраиваться только с точностью до раздела.
//
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	// БПКР
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "БухгалтерскийУчет";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("aaf6f651-1e70-11e7-9807-5404a6a1f5c8");
	Раздел.Представление = НСтр("ru = 'Бухгалтерский учет'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	// Конец БПКР
	
КонецПроцедуры

// Позволяет задать таблицы и поля объектов для проверки запрета изменения данных.
// Для добавления нового источника в ИсточникиДанных см. ДатыЗапретаИзменения.ДобавитьСтроку.
//
// Вызывается из процедуры ИзменениеЗапрещено общего модуля ДатыЗапретаИзменения,
// используемой в подписке на событие ПередЗаписью объекта для проверки наличия
// запретов и отказа от изменений запрещенного объекта.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений - с колонками:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например: "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя раздела дат запрета, указанного в
//                   процедуре ПриЗаполненииРазделовДатЗапретаИзменения (см. выше).
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например: "Организация", "Товары.Склад".
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	// БПКР
	// Данные(Таблица, ПолеДаты, Раздел, ПолеОбъекта)
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ._ДемоЧек", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АвансовыйОтчет", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АктСверкиВзаиморасчетов", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеБланковСчетовФактур", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.БольничныйЛист", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВводНачальныхОстатков", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВедомостьЗаработнойПлаты", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратТоваровОтПокупателя", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратТоваровПоставщику", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыработкаОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ГТДПоИмпорту", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ДвижениеМБП", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Доверенность", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ДополнительныеРасходы", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗакрытиеМесяца", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗакрытиеМесяцаЗП", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗаявлениеОВвозеТоваров", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗемельныйНалог", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияМБП", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияТоваров", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИсполнительныйЛист", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КадровоеПеремещение", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КассоваяСмена", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Командировка", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Конвертация", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.МодернизацияОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеЗарплаты", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Неявка", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Отработка", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОперацияБух", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Отпуск", "Дата", "БухгалтерскийУчет", "Организация");	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоБланкамСчетовФактур", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоКосвеннымНалогам", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоНалогуНаИмущество", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоНДС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоНСП", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетыПоСоциальномуФонду", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетыПоПодоходномуНалогу", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоВыплатамИУдержаниямПН", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеТоваров", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПлатежноеПоручениеВходящее", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПлатежноеПоручениеИсходящее", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПлатежныйОрдерСписаниеДС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеТоваровУслуг", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриемНаРаботу", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПринятиеКУчетуОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриходныйКассовыйОрдер", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Профвзносы", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РаботаВВыходныеИПраздничныеДни", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РаботаСверхурочно", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РазовоеУдержание", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РасходныйКассовыйОрдер", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РеализацияТоваровУслуг", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегламентированныйОтчет", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеТоваров", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СправкиДляПН", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СчетНаОплатуПокупателю", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СчетНаОплатуПоставщика", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СчетФактураВыписанный", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СчетФактураПолученный", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ТрудовоеСоглашение", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Увольнение", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПлановоеУдержание", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УдержаниеПоГрафику", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УстановкаТарифовКомандировочных", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УстановкаЦенНоменклатуры", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НалогНаМусор", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаДолга", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КорректировкаНУ", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОприходованиеТоваров", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЕдинаяНалоговаяДекларация", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗаказНаПроизводство", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоРоялти", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоПроизводству", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПроизводстваЗаСмену", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗакрытиеЗаказовНаПроизводство", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетПоЕдиномуНалогу", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ТекущийРасчетНалогаНаПрибыль", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияНезавершенногоПроизводства", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ТребованиеНакладная", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.УведомлениеОПолученииТоваров", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетВзаимнойОТорговлеЕАЭС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.КомплектацияОС", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СводПоРознице", "Дата", "БухгалтерскийУчет", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.КурсыВалют", "Период", "", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.МетодыРаспределенияКосвенныхРасходовОрганизаций", "Период", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.УчетнаяПолитикаОрганизаций", "Период", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.УчетнаяПолитикаПоПерсоналу", "Период", "БухгалтерскийУчет", "Организация");
	// Конец БПКР
	
КонецПроцедуры

// Позволяет переопределить выполнение проверки запрета изменения произвольным образом.
//
// Если проверка выполняется в процессе записи документа, то в свойстве ДополнительныеСвойства документа Объект
// имеется свойство РежимЗаписи.
//  
// Параметры:
//  Объект       - СправочникОбъект,
//                 ДокументОбъект,
//                 ПланВидовХарактеристикОбъект,
//                 ПланСчетовОбъект,
//                 ПланВидовРасчетаОбъект,
//                 БизнесПроцессОбъект,
//                 ЗадачаОбъект,
//                 ПланОбменаОбъект, 
//                 РегистрСведенийНаборЗаписей,
//                 РегистрНакопленияНаборЗаписей,
//                 РегистрБухгалтерииНаборЗаписей,
//                 РегистрРасчетаНаборЗаписей - проверяемый элемент данных или набор записей 
//                 (который передается из обработчиков ПередЗаписью и ПриЧтенииНаСервере).
//
//  ПроверкаЗапретаИзменения    - Булево - установить в Ложь, чтобы пропустить проверку запрета изменения данных.
//  УзелПроверкиЗапретаЗагрузки - ПланыОбменаСсылка, Неопределено - установить в Неопределено, чтобы 
//                                пропустить проверку запрета загрузки данных.
//  ВерсияОбъекта               - Строка - установить "СтараяВерсия" или "НоваяВерсия", чтобы
//                                выполнить проверку только старой (в базе данных) 
//                                или только новой версии объекта (в параметре Объект).
//                                По умолчанию содержит значение "" - проверяются обе версии объекта сразу.
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
