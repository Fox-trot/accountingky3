﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Формирует структуру таблиц проверок и групп проверок для дальнейшего использования.
//
// Возвращаемое значение:
//    Структура со значениями:
//       * ГруппыПроверок - ТаблицаЗначений - Таблица групп проверок.
//       * Проверки       - ТаблицаЗначений - Таблица проверок.
//
Функция ПроверкиВеденияУчета() Экспорт
	
	ГруппыПроверок = НоваяТаблицаГруппПроверок();
	Проверки       = НоваяТаблицаПроверок();
	
	ДобавитьСистемныеПроверкиВеденияУчета(ГруппыПроверок, Проверки);
	
	ИнтеграцияПодсистемБСП.ПриОпределенииПроверок(ГруппыПроверок, Проверки);
	КонтрольВеденияУчетаПереопределяемый.ПриОпределенииПроверок(ГруппыПроверок, Проверки);
	
	// Для обратной совместимости.
	КонтрольВеденияУчетаПереопределяемый.ПриОпределенииПрикладныхПроверок(ГруппыПроверок, Проверки);
	ОбеспечитьОбратнуюСовместимость(Проверки);
	
	Возврат Новый ФиксированнаяСтруктура("ГруппыПроверок, Проверки", ГруппыПроверок, Проверки);
	
КонецФункции

// Возвращает массив типов, включающий в себя все возможные объектные типы конфигурации.
//
// Возвращаемое значение:
//    Массив - Массив объектных типов.
//
Функция ОписаниеТипаВсеОбъекты() Экспорт
	
	МассивТипов = Новый Массив;
	
	МассивВидовМетаданных = Новый Массив;
	МассивВидовМетаданных.Добавить(Метаданные.Документы);
	МассивВидовМетаданных.Добавить(Метаданные.Справочники);
	МассивВидовМетаданных.Добавить(Метаданные.ПланыОбмена);
	МассивВидовМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	МассивВидовМетаданных.Добавить(Метаданные.ПланыСчетов);
	МассивВидовМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	МассивВидовМетаданных.Добавить(Метаданные.Задачи);
	
	Для Каждого ВидМетаданных Из МассивВидовМетаданных Цикл
		Для Каждого ОбъектМетаданных Из ВидМетаданных Цикл
			
			РазделенноеИмя = СтрРазделить(ОбъектМетаданных.ПолноеИмя(), ".");
			Если РазделенноеИмя.Количество() < 2 Тогда
				Продолжить;
			КонецЕсли;
			
			МассивТипов.Добавить(Тип(РазделенноеИмя.Получить(0) + "Объект." + РазделенноеИмя.Получить(1)));
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(МассивТипов);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. КонтрольВеденияУчетаПереопределяемый.ПриОпределенииПроверок
Процедура ДобавитьСистемныеПроверкиВеденияУчета(ГруппыПроверок, Проверки)
	
	ГруппаПроверок = ГруппыПроверок.Добавить();
	ГруппаПроверок.Наименование                 = НСтр("ru='Системные проверки'");
	ГруппаПроверок.Идентификатор                = "СистемныеПроверки";
	ГруппаПроверок.КонтекстПроверокВеденияУчета = "СистемныеПроверки";
	
	Проверка = Проверки.Добавить();
	Проверка.ИдентификаторГруппы          = ГруппаПроверок.Идентификатор;
	Проверка.Наименование                 = НСтр("ru='Проверка незаполненных обязательных реквизитов'");
	Проверка.Причины                      = НСтр("ru='Некорректная синхронизация данных с другими программами или импорт данных.'");
	Проверка.Рекомендация                 = НСтр("ru='Перенастроить синхронизацию данных или заполнить обязательные реквизиты вручную.
		|Для этого можно также воспользоваться групповым изменением реквизитов (в разделе Администрирование).
		|В случае обнаружения незаполненных обязательных полей у регистров, то в большинстве
		|случаев, для устранения проблемы, достаточно заполнить соответствующие поля в документе-регистраторе.'");
	Проверка.Идентификатор                = "СтандартныеПодсистемы.ПроверкаНезаполненныхОбязательныхРеквизитов";
	Проверка.ОбработчикПроверки           = "КонтрольВеденияУчетаСлужебный.ПроверитьНезаполненныеОбязательныеРеквизиты";
	Проверка.КонтекстПроверокВеденияУчета = "СистемныеПроверки";
	Проверка.Отключена                     = Истина;
	
	Проверка = Проверки.Добавить();
	Проверка.ИдентификаторГруппы          = ГруппаПроверок.Идентификатор;
	Проверка.Наименование                 = НСтр("ru='Проверка ссылочной целостности'");
	Проверка.Причины                      = НСтр("ru='Случайное или преднамеренное удаление данных без контроля ссылочной целостности, сбои в работе оборудования, некорректная синхронизация данных с другими программами или импорт данных, ошибки в сторонних инструментах (например, внешних обработках или расширениях).'");
	Проверка.Рекомендация                 = НСтр("ru='В зависимости от ситуации следует выбрать один из вариантов:
		|• восстановить удаленные данные из резервной копии,
		|• или очистить ссылки на удаленные данные (если они больше не требуются).'");
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Проверка.Рекомендация = Проверка.Рекомендация + Символы.ПС + Символы.ПС 
			+ НСтр("ru='Для очистки ссылок на удаленные данные следует:
			|• Завершить работу всех пользователей, установить блокировку входа в программу и сделать резервную копию информационной базы;
			|• Запустить конфигуратор, меню Администрирование - Тестирования и исправление, включить два флажка для проверки логической и ссылочной целостности
			|  См. подробнее на ИТС: https://its.1c.ru/db/v83doc#bookmark:adm:TI000000142
			|• Дождаться завершения тестирования и исправления, снять блокировку входа в программу.
			|
			|Если работа ведется в распределенной информационной базе (РИБ), то исправление следует запускать только в главном узле.
			|Затем выполнить синхронизацию с подчиненными узлами.'");
	
	КонецЕсли;
	Проверка.Рекомендация = Проверка.Рекомендация + Символы.ПС
		+ НСтр("ru='В случае обнаружения битых ссылок в регистрах, то в большинстве случаев, для устранения проблемы
		|достаточно устранить соответствующие битые ссылки в документах-регистраторах.'");
	
	Проверка.Идентификатор                = "СтандартныеПодсистемы.ПроверкаСсылочнойЦелостности";
	Проверка.ОбработчикПроверки           = "КонтрольВеденияУчетаСлужебный.ПроверитьСсылочнуюЦелостность";
	Проверка.КонтекстПроверокВеденияУчета = "СистемныеПроверки";
	Проверка.Отключена                     = Истина;
	
	Проверка = Проверки.Добавить();
	Проверка.ИдентификаторГруппы            = ГруппаПроверок.Идентификатор;
	Проверка.Наименование                   = НСтр("ru='Проверка циклических ссылок'");
	Проверка.Причины                        = НСтр("ru='Некорректная синхронизация данных с другими программами или импорт данных.'");
	Проверка.Рекомендация                   = НСтр("ru='У одного из элементов очистить ссылку на родительский элемент (для автоматического исправления нажать ссылку ниже).
		|Если работа ведется в распределенной информационной базе (РИБ), то исправление следует запускать только в главном узле.
		|Затем выполнить синхронизацию с подчиненными узлами.'");
	Проверка.Идентификатор                  = "СтандартныеПодсистемы.ПроверкаЦиклическихСсылок";
	Проверка.ОбработчикПроверки             = "КонтрольВеденияУчетаСлужебный.ПроверитьЦиклическиеСсылки";
	Проверка.ОбработчикПереходаКИсправлению = "Отчет.РезультатыПроверкиУчета.Форма.АвтоисправлениеПроблемы";
	Проверка.КонтекстПроверокВеденияУчета   = "СистемныеПроверки";
	Проверка.Отключена                      = Истина;
	
	Проверка = Проверки.Добавить();
	Проверка.ИдентификаторГруппы            = ГруппаПроверок.Идентификатор;
	Проверка.Наименование                   = НСтр("ru='Проверка отсутствующих предопределенных элементов'");
	Проверка.Причины                        = НСтр("ru='Некорректная синхронизация данных с другими программами или импорт данных, ошибки в сторонних инструментах (например, внешних обработках или расширениях).'");
	Проверка.Рекомендация                   = НСтр("ru='В зависимости от ситуации следует выбрать один из вариантов:
		|• подобрать и указать в качестве предопределенного один из существующих элементов в списке; 
		|• восстановить предопределенные элементы из резервной копии;
		|• создать отсутствующие предопределенные элементы заново (для этого нажмите ссылку ниже).'"); 
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Проверка.Рекомендация = Проверка.Рекомендация + Символы.ПС
			+ НСтр("ru='Если работа ведется в распределенной информационной базе (РИБ), то исправление следует запускать только в главном узле.
			|Затем выполнить синхронизацию с подчиненными узлами.'");
	КонецЕсли;
	Проверка.Идентификатор                  = "СтандартныеПодсистемы.ПроверкаОтсутствующихПредопределенныхЭлементов";
	Проверка.ОбработчикПроверки             = "КонтрольВеденияУчетаСлужебный.ПроверитьОтсутствующиеПредопределенныеЭлементы";
	Проверка.ОбработчикПереходаКИсправлению = "Отчет.РезультатыПроверкиУчета.Форма.АвтоисправлениеПроблемы";
	Проверка.КонтекстПроверокВеденияУчета   = "СистемныеПроверки";
	Проверка.Отключена                      = Истина;
	
	Проверка = Проверки.Добавить();
	Проверка.ИдентификаторГруппы          = ГруппаПроверок.Идентификатор;
	Проверка.Наименование                 = НСтр("ru='Проверка дублирования предопределенных элементов'");
	Проверка.Причины                      = НСтр("ru='Некорректная синхронизация данных с другими программами или импорт данных.'");
	Проверка.Рекомендация                 = НСтр("ru='Запустить поиск и удаление дублей (в разделе Администрирование).'");
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Проверка.Рекомендация = Проверка.Рекомендация + Символы.ПС  
			+ НСтр("ru='Если работа ведется в распределенной информационной базе (РИБ), то исправление следует запускать только в главном узле.
			|Затем выполнить синхронизацию с подчиненными узлами.'");
	КонецЕсли;
	Проверка.Идентификатор                = "СтандартныеПодсистемы.ПроверкаДублированияПредопределенныхЭлементов";
	Проверка.ОбработчикПроверки           = "КонтрольВеденияУчетаСлужебный.ПроверитьДублированиеПредопределенныхЭлементов";
	Проверка.КонтекстПроверокВеденияУчета = "СистемныеПроверки";
	Проверка.Отключена                    = Истина;
	
	Проверка = Проверки.Добавить();
	Проверка.ИдентификаторГруппы          = ГруппаПроверок.Идентификатор;
	Проверка.Наименование                 = НСтр("ru='Проверка отсутствия предопределенных узлов плана обмена'");
	Проверка.Причины                      = НСтр("ru='Некорректное поведение программы при работе на устаревших версиях платформы 1С:Предприятие.'");
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Проверка.Рекомендация             = НСтр("ru='Обратиться в техническую поддержку сервиса.'");
	Иначе	
		Проверка.Рекомендация             = НСтр("ru='• Перейти на версию платформы 1С:Предприятие 8.3.9.2033 или выше;
			|• Завершить работу всех пользователей, установить блокировку входа в программу и сделать резервную копию информационной базы;
			|• Запустить конфигуратор, меню Администрирование - Тестирования и исправление, включить два флажка для проверки логической и ссылочной целостности
			|  См. подробнее на ИТС: https://its.1c.ru/db/v83doc#bookmark:adm:TI000000142
			|• Дождаться завершения тестирования и исправления, снять блокировку входа в программу.
			|
			|Если работа ведется в распределенной информационной базе (РИБ), то исправление следует запускать только в главном узле.
			|Затем выполнить синхронизацию с подчиненными узлами.'");
	КонецЕсли;
	Проверка.Идентификатор                = "СтандартныеПодсистемы.ПроверкаОтсутствияПредопределенныхУзловПлановОбмена";
	Проверка.ОбработчикПроверки           = "КонтрольВеденияУчетаСлужебный.ПроверитьНаличиеПредопределенныхУзловПлановОбмена";
	Проверка.КонтекстПроверокВеденияУчета = "СистемныеПроверки";
	Проверка.Отключена                    = Истина;
	
КонецПроцедуры

// Создает таблицу групп проверок
//
// Возвращаемое значение:
//   ТаблицаЗначений с колонками:
//      * Наименование                 - Строка - Наименование группы проверок.
//      * ИдентификаторГруппы          - Строка - Строковый идентификатор группы проверок, например: 
//                                       "СистемныеПроверки", "ЗакрытиеМесяца", "ПроверкиНДС" и т.п.
//                                       Обязателен для заполнения.
//      * Идентификатор                - Строка - Строковый идентификатор группы проверок. Обязателен для заполнения.
//                                       Формат идентификатора должен быть следующим:
//                                       <Название программного продукта>.<Идентификатор проверки>. Например:
//                                       СтандартныеПодсистемы.СистемныеПроверки.
//      * КонтекстПроверокВеденияУчета - ОпределяемыйТип.КонтекстПроверокВеденияУчета - значение, дополнительно
//                                       уточняющее принадлежность группы проверок ведения учета к определенной категории.
//      * Комментарий                  - Строка - комментарий к группе проверок.
//
Функция НоваяТаблицаГруппПроверок()
	
	ГруппыПроверок        = Новый ТаблицаЗначений;
	КолонкиГруппыПроверок = ГруппыПроверок.Колонки;
	КолонкиГруппыПроверок.Добавить("Наименование",                 Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиГруппыПроверок.Добавить("Идентификатор",                Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиГруппыПроверок.Добавить("ИдентификаторГруппы",          Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиГруппыПроверок.Добавить("КонтекстПроверокВеденияУчета", Метаданные.ОпределяемыеТипы.КонтекстПроверокВеденияУчета.Тип);
	КолонкиГруппыПроверок.Добавить("Комментарий",                  Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Возврат ГруппыПроверок;
	
КонецФункции

// Создает таблицу проверок.
//
// Возвращаемое значение:
//   ТаблицаЗначений - с колонками:
//      * ИдентификаторГруппы                    - Строка - Строковый идентификатор группы проверок, например: 
//                                                 "СистемныеПроверки", "ЗакрытиеМесяца", "ПроверкиНДС" и т.п.
//                                                 Обязателен для заполнения.
//      * Наименование                           - Строка - Наименование проверки, выводимое пользователю.
//      * Причины                                - Строка - Описание возможных причин, которые приводят к возникновению
//                                                 проблемы.
//      * Рекомендация                           - Строка - Рекомендация по решению возникшей проблемы.
//      * Идентификатор                          - Строка - Строковый идентификатор элемента. Обязателен для заполнения.
//                                                 Формат идентификатора должен быть следующим:
//                                                 <Название программного продукта>.<Идентификатор проверки>. Например:
//                                                 СтандартныеПодсистемы.СистемныеПроверки.
//      * ДатаНачалаПроверки                     - Дата - Пороговая дата, обозначающая границу проверяемых
//                                                 объектов (только для объектов с датой). Объекты, дата которых меньше
//                                                 указанной, не следует проверять. По умолчанию не заполнено (т.е.
//                                                 проверять все).
//      * ЛимитПроблем                           - Число - Количество проверяемых объектов. По умолчанию 1000. 
//                                                 Если указан 0, то следует проверять все объекты.
//      * ОбработчикПроверки                     - Строка - Имя экспортной процедуры-обработчика серверного общего 
//                                                 модуля в виде ИмяМодуля.ИмяПроцедуры. 
//      * ОбработчикПереходаКИсправлению         - Строка - Имя экспортной процедуры-обработчика клиентского общего 
//                                                 модуля для перехода к исправлению проблемы в виде ИмяМодуля.ИмяПроцедуры.
//      * БезОбработчикаПроверки                 - Булево - признак служебной проверки, которая не имеет процедуры-обработчика.
//      * ЗапрещеноИзменениеВажности             - Булево - Если Истина, то администратор не сможет перенастраивать 
//                                                 важность данной проверки.
//      * КонтекстПроверокВеденияУчета           - ОпределяемыйТип.КонтекстПроверокВеденияУчета - значение, дополнительно 
//                                                 уточняющее принадлежность проверки ведения учета к определенной группе 
//                                                 или категории.
//      * УточнениеКонтекстаПроверокВеденияУчета - ОпределяемыйТип.УточнениеКонтекстаПроверокВеденияУчета - второе значение, 
//                                                 дополнительно уточняющее принадлежность проверки ведения учета 
//                                                 к определенной группе или категории.
//      * ДополнительныеПараметры                - ХранилищеЗначений - Дополнительная информация о проверке для программного
//                                                 использования.
//      * Комментарий                            - Строка - комментарий к проверке.
//      * Отключена                              - Булево - если Истина, то проверка не будет выполняться в фоне по расписанию.
//
Функция НоваяТаблицаПроверок()
	
	Проверки        = Новый ТаблицаЗначений;
	КолонкиПроверок = Проверки.Колонки;
	КолонкиПроверок.Добавить("ИдентификаторГруппы",                    Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("Наименование",                           Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("Причины",                                Новый ОписаниеТипов("Строка"));
	КолонкиПроверок.Добавить("Рекомендация",                           Новый ОписаниеТипов("Строка"));
	КолонкиПроверок.Добавить("Идентификатор",                          Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("ДатаНачалаПроверки",                     Новый ОписаниеТипов("Дата", , , , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	КолонкиПроверок.Добавить("ЛимитПроблем",                           Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(8, 0, ДопустимыйЗнак.Неотрицательный)));
	КолонкиПроверок.Добавить("ОбработчикПроверки",                     Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("ОбработчикПереходаКИсправлению",         Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("БезОбработчикаПроверки",                 Новый ОписаниеТипов("Булево"));
	КолонкиПроверок.Добавить("ЗапрещеноИзменениеВажности",             Новый ОписаниеТипов("Булево"));
	КолонкиПроверок.Добавить("КонтекстПроверокВеденияУчета",           Метаданные.ОпределяемыеТипы.КонтекстПроверокВеденияУчета.Тип);
	КолонкиПроверок.Добавить("УточнениеКонтекстаПроверокВеденияУчета", Метаданные.ОпределяемыеТипы.УточнениеКонтекстаПроверокВеденияУчета.Тип);
	КолонкиПроверок.Добавить("ДополнительныеПараметры",                Новый ОписаниеТипов("ХранилищеЗначения"));
	КолонкиПроверок.Добавить("ИдентификаторРодителя",                  Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("Комментарий",                            Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	КолонкиПроверок.Добавить("Отключена",                              Новый ОписаниеТипов("Булево"));
	Проверки.Индексы.Добавить("Идентификатор");
	
	Возврат Проверки;
	
КонецФункции

Процедура ОбеспечитьОбратнуюСовместимость(Проверки)
	
	Для Каждого Проверка Из Проверки Цикл
		
		Если ЗначениеЗаполнено(Проверка.ИдентификаторГруппы) Тогда
			Продолжить;
		КонецЕсли;
		
		Проверка.ИдентификаторГруппы = Проверка.ИдентификаторРодителя;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти