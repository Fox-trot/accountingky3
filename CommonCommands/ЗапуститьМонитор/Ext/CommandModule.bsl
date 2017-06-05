﻿&НаКлиенте
Функция ДанныеДенежногоДокумента(ДанныеФормыСтруктура)
	СтруктураДанных = Новый Структура("Ссылка, Организация, Номер, Дата, СуммаДокумента, Операция, Контрагент, ФизЛицо, БанковскийСчет, БанковскийСчетПолучателя, 
										|Касса, СчетУчета, ДокументОснование, ВалютаДенежныхСредств, Курс, Комментарий, Автор");
	ЗаполнитьЗначенияСвойств(СтруктураДанных, ДанныеФормыСтруктура);
	
	Возврат СтруктураДанных;
КонецФункции // ()

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Попытка
		ИмяФормы = ПараметрыВыполненияКоманды.Источник.ИмяФормы;
		
		// Документы ППИ, ППВ, РКО, ПКО и Конвертация
		Если ИмяФормы = "Документ.ПриходныйКассовыйОрдер.Форма.ФормаДокумента" Тогда 
			СтруктураДанных = ДанныеДенежногоДокумента(ПараметрыВыполненияКоманды.Источник.Объект);
			ПараметрыФормы = Новый Структура("СтруктураДанных, КлючНазначенияИспользования", 
							СтруктураДанных,
							"ЗапускМонитораИзДокумента");
							
			ОткрытьФорму("Отчет.МониторДенежныхСредств.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
				
		ИначеЕсли ИмяФормы = "Документ.ПлатежноеПоручениеИсходящее.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ПлатежноеПоручениеВходящее.Форма.ФормаДокумента" 
			ИЛИ ИмяФормы = "Документ.ПриходныйКассовыйОрдер.Форма.ФормаДокумента" 
			ИЛИ ИмяФормы = "Документ.Конвертация.Форма.ФормаДокумента" Тогда 
			СтруктураДанных = ДанныеДенежногоДокумента(ПараметрыВыполненияКоманды.Источник.Объект);
			ПараметрыФормы = Новый Структура("СтруктураДанных, КлючНазначенияИспользования", 
							СтруктураДанных,
							"ЗапускМонитораИзДокумента");
							
			ОткрытьФорму("Отчет.МониторДенежныхСредств.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
				
		// Справочник ОсновныеСредства
		ИначеЕсли ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаЭлемента" Тогда 
			ПараметрыФормы = Новый Структура("ОсновноеСредство, КлючНазначенияИспользования", 
							,
							"ЗапускМонитораИзДокумента");
							
			ОткрытьФорму("Обработка.МониторОС.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
			
		ИначеЕсли ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаСписка" Тогда 
			ПараметрыФормы = Новый Структура("ОсновноеСредство, КлючНазначенияИспользования", 
							ПараметрыВыполненияКоманды.Источник.Элементы.Список.ТекущиеДанные.Ссылка,
							"ЗапускМонитораИзДокумента");
							
			ОткрытьФорму("Обработка.МониторОС.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
			
		ИначеЕсли ИмяФормы = "Документ.МодернизацияОС.Форма.ФормаДокумента" Тогда
			ПараметрыФормы = Новый Структура("ОсновноеСредство, КлючНазначенияИспользования", 
							ПараметрыВыполненияКоманды.Источник.Объект.ОсновноеСредство,
							"ЗапускМонитораИзДокумента");
							
			ОткрытьФорму("Обработка.МониторОС.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);			
			
		ИначеЕсли ПараметрыВыполненияКоманды.Источник.Элементы.Страницы.ТекущаяСтраница.Заголовок = "ОС" ИЛИ 
			ПараметрыВыполненияКоманды.Источник.Элементы.Страницы.ТекущаяСтраница.Заголовок = "Основные средства" Тогда
			Если ПараметрыВыполненияКоманды.Источник.Элементы.ОС.ТекущиеДанные = Неопределено Тогда
				Возврат;
			КонецЕсли;	
			СтрокаТабличнойЧасти = ПараметрыВыполненияКоманды.Источник.Элементы.ОС.ТекущиеДанные;
			ПараметрыФормы = Новый Структура("ОсновноеСредство, КлючНазначенияИспользования", 
							СтрокаТабличнойЧасти.ОсновноеСредство,
							"ЗапускМонитораИзДокумента");
							
			ОткрытьФорму("Обработка.МониторОС.Форма.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
			
		КонецЕсли;
	
	Исключение
	
	КонецПопытки;
	
КонецПроцедуры