﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Функция ДанныеДенежногоДокумента(ДанныеФормыСтруктура)
	СтруктураДанных = Новый Структура("Ссылка, Организация, Дата, СуммаДокумента, Операция, Контрагент, ФизЛицо, БанковскийСчет, БанковскийСчетПолучателя, 
										|Касса, СчетУчета, ДокументОснование, ВалютаДенежныхСредств, Курс, Комментарий, Автор");
	ЗаполнитьЗначенияСвойств(СтруктураДанных, ДанныеФормыСтруктура);
	
	Возврат СтруктураДанных;	
КонецФункции // ()

&НаКлиенте
Функция ДанныеДокументаЗакрытиеМесяца(Источник)
	Данныеобъекта = Источник.Объект;
	СтруктураДанных = Новый Структура("Ссылка, Организация, Дата, ИмяТабличнойЧасти, ГруппаНУ, ОсновноеСредство");
	ЗаполнитьЗначенияСвойств(СтруктураДанных, Данныеобъекта);
	
	Если Источник.ТекущийЭлемент.Имя = "НалоговаяАмортизация" Тогда
		СтрокаТабличнойЧасти = Источник.Элементы.НалоговаяАмортизация.ТекущиеДанные;
		СтруктураДанных.ИмяТабличнойЧасти = "НалоговаяАмортизация";
		ЗаполнитьЗначенияСвойств(СтруктураДанных, СтрокаТабличнойЧасти, "ГруппаНУ, ОсновноеСредство");	
	ИначеЕсли Источник.ТекущийЭлемент.Имя = "НалоговаяВыверка" Тогда
		СтруктураДанных.ИмяТабличнойЧасти = "НалоговаяВыверка";		
	КонецЕсли;
	
	Возврат СтруктураДанных;

КонецФункции

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ИмяФормы = "";	
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения") Тогда 
		ИмяФормы = ПараметрыВыполненияКоманды.Источник.ИмяФормы;
	КонецЕсли;			
	
	// Документы ППИ, ППВ, РКО, ПКО и Конвертация.
	Если ИмяФормы = "Документ.ПриходныйКассовыйОрдер.Форма.ФормаДокумента" Тогда 
		СтруктураДанных = ДанныеДенежногоДокумента(ПараметрыВыполненияКоманды.Источник.Объект);
		ПараметрыФормы = Новый Структура("СтруктураДанных, КлючНазначенияИспользования", 
						СтруктураДанных,
						"ЗапускМонитораИзДокумента");
						
		//ОткрытьФорму("Отчет.МониторДенежныхСредств.Форма.Форма", 
		//	ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
		//	ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
			
	ИначеЕсли ИмяФормы = "Документ.ПлатежноеПоручениеИсходящее.Форма.ФормаДокумента"
		ИЛИ ИмяФормы = "Документ.ПлатежноеПоручениеВходящее.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ОплатаПлатежнойКартой.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ПриходныйКассовыйОрдер.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Конвертация.Форма.ФормаДокумента" Тогда 
		СтруктураДанных = ДанныеДенежногоДокумента(ПараметрыВыполненияКоманды.Источник.Объект);
		ПараметрыФормы = Новый Структура("СтруктураДанных, КлючНазначенияИспользования", 
						СтруктураДанных,
						"ЗапускМонитораИзДокумента");
						
		//ОткрытьФорму("Отчет.МониторДенежныхСредств.Форма.Форма", 
		//	ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
		//	ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
			
	// Основные средства - Форма элемента справочника.
	ИначеЕсли ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаЭлемента" Тогда 
		ПараметрыФормы = Новый Структура("ОсновноеСредство, КлючНазначенияИспользования", 
						,
						"ЗапускМонитораИзДокумента");
						
		ОткрытьФорму("Обработка.МониторОС.Форма.ОсновнаяФорма", 
			ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	// Основные средства - Форма списка справочника.
	ИначеЕсли ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаСписка" Тогда 
		ПараметрыФормы = Новый Структура("ОсновноеСредство, КлючНазначенияИспользования", 
						ПараметрыВыполненияКоманды.Источник.Элементы.Список.ТекущиеДанные.Ссылка,
						"ЗапускМонитораИзДокумента");
						
		ОткрытьФорму("Обработка.МониторОС.Форма.ОсновнаяФорма", 
			ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	// Основные средства - Форма документа модернизация.
	ИначеЕсли ИмяФормы = "Документ.МодернизацияОС.Форма.ФормаДокумента" Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ОсновноеСредство", ПараметрыВыполненияКоманды.Источник.Объект.ОсновноеСредство);
		ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ЗапускМонитораИзДокумента");
		ПараметрыФормы.Вставить("ДатаНачала", НачалоМесяца(ПараметрыВыполненияКоманды.Источник.Объект.Дата));
		ПараметрыФормы.Вставить("ДатаОкончания", КонецМесяца(ПараметрыВыполненияКоманды.Источник.Объект.Дата));
						
		ОткрытьФорму("Обработка.МониторОС.Форма.ОсновнаяФорма", 
			ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	// Основные средства - Форма документа.
	ИначеЕсли ИмяФормы = "Документ.ВыработкаОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ИнвентаризацияОС.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.МодернизацияОС.Форма.ФормаДокумента" 
		Или ИмяФормы = "Документ.ПринятиеКУчетуОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.СписаниеОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.КомплектацияОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ПеремещениеОС.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента" Тогда 
		
		СтрокаТабличнойЧасти = ПараметрыВыполненияКоманды.Источник.Элементы.ОС.ТекущиеДанные;
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ОсновноеСредство", ?(СтрокаТабличнойЧасти = Неопределено, 
				ПредопределенноеЗначение("Справочник.ОсновныеСредства.ПустаяСсылка"), СтрокаТабличнойЧасти.ОсновноеСредство));
		ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ЗапускМонитораИзДокумента");
		ПараметрыФормы.Вставить("ДатаНачала", НачалоМесяца(ПараметрыВыполненияКоманды.Источник.Объект.Дата));
		ПараметрыФормы.Вставить("ДатаОкончания", КонецМесяца(ПараметрыВыполненияКоманды.Источник.Объект.Дата));
					
		ОткрытьФорму("Обработка.МониторОС.Форма.ОсновнаяФорма", 
			ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	// Основные средства - Форма документа ввод начальных остатков - раздел ОС.
	ИначеЕсли ИмяФормы = "Документ.ВводНачальныхОстатков.Форма.ФормаДокумента"
		И ПараметрыВыполненияКоманды.Источник.Объект.РазделУчета = "Основные средства" Тогда 
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаНачала", НачалоМесяца(ПараметрыВыполненияКоманды.Источник.Объект.Дата));
		ПараметрыФормы.Вставить("ДатаОкончания", КонецМесяца(ПараметрыВыполненияКоманды.Источник.Объект.Дата));
		
		ОткрытьФорму("Обработка.МониторОС.Форма.ОсновнаяФорма", 
			ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
	// Заработная плата
	ИначеЕсли ИмяФормы = "Документ.ЗакрытиеМесяцаЗП.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ВедомостьЗаработнойПлаты.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.КадровоеПеремещение.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ПриемНаРаботу.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Профвзносы.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ИзменениеСтатусовИДополнительныхВычетов.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ТрудовоеСоглашение.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Увольнение.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.УстановкаТарифовКомандировочных.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.БольничныйЛист.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Командировка.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Неявка.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Отпуск.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.Отработка.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.РаботаВВыходныеИПраздничныеДни.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.РаботаСверхурочно.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ИсполнительныйЛист.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.НачислениеЗарплаты.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ПлановоеУдержание.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.РазовоеУдержание.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.УдержаниеЗаПериод.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.ОтчетыПоСоциальномуФонду.Форма.ФормаДокумента"  
		ИЛИ ИмяФормы = "Документ.ОтчетыПоПодоходномуНалогу.Форма.ФормаДокумента"  
		ИЛИ ИмяФормы = "Документ.ОтчетПоВыплатамИУдержаниямПН.Форма.ФормаДокумента" Тогда 
		
		ОткрытьФорму("Обработка.МониторЗаработнойПлаты.Форма", 
			ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
			
	// Закрытие месяца - налог на прибыль
	ИначеЕсли ИмяФормы = "Документ.ЗакрытиеМесяца.Форма.ФормаДокумента" Тогда 
		Если ПараметрыВыполненияКоманды.Источник.ТекущийЭлемент.Имя = "НалоговаяАмортизация" 
			ИЛИ ПараметрыВыполненияКоманды.Источник.ТекущийЭлемент.Имя = "НалоговаяВыверка" Тогда
			
			СтруктураДанных = ДанныеДокументаЗакрытиеМесяца(ПараметрыВыполненияКоманды.Источник);
			ПараметрыФормы = Новый Структура("СтруктураДанных, КлючНазначенияИспользования", 
							СтруктураДанных,
							"ЗапускМонитораИзДокумента");
			
			ОткрытьФорму("Обработка.МониторНалогаНаПрибыль.Форма", 
				ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, 
				ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
